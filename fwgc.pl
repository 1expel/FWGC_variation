/*
Farmer, Wolf, Goat, Cabbage
East, West
1 or 2 per boat
farmer is only solo
Wolf and Goat cannot be together
Goat and Cabbage cannot be together
*/

/*
- this code finds solutions to the FWGC puzzle
- run by executing the line below
*/

/* go(state(east, east, east, east), state(west, west, west, west)). */
/* go(state(east, east, east, east), state(west, east, west, east)). */

/* 
- facts, that when opposite is called, vars get set to their constants 
*/
opposite(east, west).
opposite(west, east).

/* 
- both opposite lines trigger, (F = east,X = west), (F = west,X = east)
- true if variables lineup, aka F != X and X == X
*/
unsafe(state(F, X, X, _)) :- opposite(F, X). 
unsafe(state(F, _, X, X)) :- opposite(F, X). 

/*
- all possible moves
- move from state to state, as long as X and Y are opposite
- move from state to state, as long as safe
- opposite reduces lines in half by doing east to west and west to east in one line
*/
move(state(X, X, G, C), state(Y, Y, G, C)) :-
	opposite(X, Y),
	not(unsafe(state(Y, Y, G, C))).

move(state(X, W, X, C), state(Y, W, Y, C)) :-
	opposite(X, Y),
	not(unsafe(state(Y, W, Y, C))).

move(state(X, W, G, X), state(Y, W, G, Y)) :-
	opposite(X, Y),
	not(unsafe(state(Y, W, G, Y))).

move(state(X, W, G, C), state(Y, W, G, C)) :-
	opposite(X, Y),
	not(unsafe(state(Y, W, G, C))).
	

/*
- checks if an element is a member of a list
*/
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

/*
- path base case
- executed if first 2 parameters are equal
- since the last parameter is never assigned a value, we can assign it the value T 
- need to do :- !. to stop because in the other path() calls we have recursive calls stacked
  from move() and unsafe() that are waiting to be executed???
*/
path(Goal, Goal, Visited, Visited).

/*
- path recursive case
- executed if first 2 parameters are not equal
- cut created after true result returns to path so we do not back track to recursive calls stacked
  from move() that are waiting to be executed. (I THINK)
- lines are executed in depth first, move(), member(), path(), 
  NOT: move(), move(), move(), move() kind of thing
  the first move that is true gets executed and then member goes (I THINK)
*/
path(State, Goal, Visited, L1) :-
	move(State, State1),
	not(member(State1, Visited)),
	path(State1, Goal, [State1|Visited], L1),
	!.

/*
- starts the code
*/
go(State, Goal) :-
	path(State, Goal, [State], Visited),
	write("A solution path is: "), nl,
	write(Visited).

/*
- Questions About Sample Code:
- when path() hits the base case,
  I can just set the last variable to something after it is useless during all recursion?
- why does the second opposite need :- !.
- why does the goal path need :- !.
- why does go have a call with anonymous variables
*/