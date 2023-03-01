/*
PROBLEM
- As a wildfire rages through the grasslands, three lions and three wildebeest flee for their lives. 
- To escape the inferno, they must cross over to the left bank of a crocodile-infested river. 
- The boat can carry up to two animals at a time and 
  it needs at least one lion or wildebeest on the boat to cross the river. 
- lions can never outnumber the wildebeest on either side of the river. 
- If the lions ever outnumbered the wildebeest on either side of the river, even for a moment, 
  the lions would eat the wildebeest. 
- Can you help them figure out how to get across on the one raft available without losing any lives? 
*/

/* 
RUN THE CODE
?- go(state(3, 3, 0, 0, left), state(0, 0, 3, 3, right)).
*/

/*
STATE
- state(L1, W1, L2, W2)
- L1: lion right, W1: wildebeest right, L2: lion left, W2: wilebeest left
*/

/* 
INCREMENTS 
- increments and decrements appropriate values
*/

/* increment/decrement by 1 */
increment1(X, Y, X1, Y1) :- 
    0 < X,
    X1 is X - 1,
    Y1 is Y + 1.

/* increment/decrement by 2 */
increment2(X, Y, X1, Y1) :-
    1 < X,
    X1 is X - 2,
    Y1 is Y + 2.

/* 
MOVES 
- 1 move for each direction (right to left & left to right)
*/

/* 2 lions move */
move(state(L1, W1, L2, W2, left), state(L3, W1, L4, W2, right)) :- increment2(L1, L2, L3, L4).
move(state(L1, W1, L2, W2, right), state(L3, W1, L4, W2, left)) :- increment2(L2, L1, L4, L3).

/* 2 wildebeest move */
move(state(L1, W1, L2, W2, left), state(L1, W3, L2, W4, right)) :- increment2(W1, W2, W3, W4).
move(state(L1, W1, L2, W2, right), state(L1, W3, L2, W4, left)) :- increment2(W2, W1, W4, W3).

/* 
1 lion & 1 wildebeest move
- must be able to increment/decrement both wildebeest AND lion by 1 for move to be valid
*/
move(state(L1, W1, L2, W2, left), state(L3, W3, L4, W4, right)) :- 
    increment1(L1, L2, L3, L4), 
    increment1(W1, W2, W3, W4).
move(state(L1, W1, L2, W2, right), state(L3, W3, L4, W4, left)) :- 
    increment1(L2, L1, L4, L3), 
    increment1(W2, W1, W4, W3).

/* 1 lion moves */
move(state(L1, W1, L2, W2, left), state(L3, W1, L4, W2, right)) :- increment1(L1, L2, L3, L4).
move(state(L1, W1, L2, W2, right), state(L3, W1, L4, W2, left)) :- increment1(L2, L1, L4, L3).

/* 1 wildebeest moves */
move(state(L1, W1, L2, W2, left), state(L1, W3, L2, W4, right)) :- increment1(W1, W2, W3, W4).
move(state(L1, W1, L2, W2, right), state(L1, W3, L2, W4, left)) :- increment1(W2, W1, W4, W3).

/* 
UNSAFE
- unsafe if wildebeests on either side are outnumbered iff wildebeest != 0
*/

unsafe(state(L1, W1, L2, W2, _)) :-
    (W1 =\= 0, W1 < L1);
    (W2 =\= 0, W2 < L2).

/* 
MEMBERSHIP 
- ensures new state has not already been visited
*/

member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

/* PATH */

/*
base case, goal has been reached 
- 4th param is set to Visited as it is never set in recursive calls
*/
path(Goal, Goal, Visited, Visited).

/* 
recursive case
- !. at the end for when base case is true, 
  backtracking is cut and no more solutions will be looked for
*/
path(State, Goal, Visited, L) :- 
    move(State, State1),
    not(unsafe(State1)),
    not(member(State1, Visited)),
    path(State1, Goal, [State1|Visited], L),
    !. 

/* GO */

go(State, Goal) :-
    path(State, Goal, [State], Visited),
    write('A solution path is: '), 
    nl,
    reverse_print_list(Visited).

/* 
AUX func
- prints the path in reverse (correct) order
*/

reverse_print_list([]).
reverse_print_list([H|T]) :-
    reverse_print_list(T),
    write(H), 
    nl.
