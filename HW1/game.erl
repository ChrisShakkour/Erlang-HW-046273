% Comments
%

% module decleration
-module(game).


% module export
-export([canWin/1 , nextMove/1 , explanation/0]).


canWin(1) -> true;
canWin(2) -> true;
canWin(3) -> false;
canWin(N) when (N>0) and (is_integer(N)) -> canWin(N-3).


nextMove(1) -> {true,1};
nextMove(2) -> {true,2};
nextMove(3) -> false;
nextMove(N) when (N>0) and (is_integer(N))  -> nextMove(N-3).

explanation() -> { "The difficulty in implementing the solution to the game using tail recursion is the need to know what happened in the two steps that preceded the current state and not only what happened in the step that preceded the current state in order to calculate the next step" }.
