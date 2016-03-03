#!/usr/bin/env escript


%Drop the last digit from the number. The last digit is what we want to check against
%Reverse the numbers
%Multiply the digits in odd positions (1, 3, 5, etc.) by 2 and subtract 9 to all any result higher than 9
%Add all the numbers together
%The check digit (the last number of the card) is the amount that you would need to add to get a multiple of 10 (Modulo 10)

main([Args]) ->
	%Seperated = string:tokens(Args,"," ), initally I had to enter it in as csv but I figured out how to take the card number in as all one string
	Converted = convert_to_list(Args),
	validateCard(Converted).

validateCard(Converted) ->
	LastDigit = checkLast(Converted),
	OneLess = dropLast(Converted),
	Unreversed = lists:reverse(OneLess),
	OddsMultiplied = oddPositions(Unreversed),
	Subtracted = subtractLarge(OddsMultiplied),
	Alltogether = sumCard(Subtracted),
	ValidOrNot = checkSum(Alltogether,LastDigit),
	reportValidity(ValidOrNot).

%Reports the last number of the credit card
checkLast([H|_]) ->
	H.

%Returns the credit card number without the last number
dropLast([_|T]) ->
	T.

%Multiplies the odd positions of the card number by 2
oddPositions(A) ->
	oddPositions(A,1,[]).
oddPositions([],_,Acc) ->
	Acc;
oddPositions([H|T],B,Acc) ->
	if B rem 2 =:= 1 ->
		oddPositions(T,B+1,[H*2|Acc]);
	B rem 2 =:= 0 ->
		oddPositions(T,B+1,[H|Acc])
	end.

%convert_to_list(C) ->    this is the function I was using to convert the csv list into a normal erlang list of ints to operate on
%	convert_to_list(C,[]).
%convert_to_list([],Acc) ->
%	Acc;
%convert_to_list([H|T],Acc) ->
%	{D,_} = string:to_integer(H),
%	convert_to_list(T,[D|Acc]).

%Converts our string into a list of ints
convert_to_list(String) ->
         convert_to_list(String,[]).
convert_to_list([], Acc) ->
         Acc;
convert_to_list(String, Acc) ->
         A = string:substr(String, 2),
         B = string:substr(String, 1, 1),
         {C,_} = string:to_integer(B),
         convert_to_list(A,[C|Acc]).


%Subtracts the numbers in odd positions that are greater than 9
subtractLarge(E) ->
	subtractLarge(E,1,[]).
subtractLarge([],_,Acc) ->
	Acc;
subtractLarge([H|T], B, Acc) ->
	if (B rem 2 =:= 1) and (H > 9) ->
		subtractLarge(T,B+1, [H-9|Acc]);
	(B rem 2 =:= 0) or (H =< 9) ->
		subtractLarge(T,B+1, [H|Acc])
	end.

%Sums up all of the numbers after their transformations
sumCard(X) ->
	sumCard(X,0).
sumCard([],Acc) ->
	Acc;
sumCard([H|T],Acc) ->
	sumCard(T,Acc+H).

%Checks whether the sum plus the inital removed digit will give us a 0 when modded by 10
checkSum(Sum,EndDigit) ->
	if (Sum+EndDigit) rem 10 =:= 0 ->
		true;
	(Sum+EndDigit) rem 10 =/= 0 ->
		false
	end.

%Reports the results
reportValidity(ValidOrNot) ->
	if ValidOrNot =:= true ->
		io:format("This is a valid credit card number~n");
	ValidOrNot =/= true ->
		io:format("This is not a valid credit card number~n")
	end.
