% Comments
% -------------------------------------------------
% typdefs:
% {rectangle, {dim, Width, Height}} -> squere as a private case.
% {triangle, {dim, Base, Height}}
% {ellipse, {radius, Radius1, Radius2}} -> circle as private case

% module decleration
-module(shapes).

% module export
-export([shapesArea/1,
         squaresArea/1,
         trianglesArea/1,
         shapesFilter/1,
         shapesFilter2/1]).


% Area function of a rectangle:
area({rectangle, {dim, Width, Height}})     
    when Width > 0   andalso Height  > 0
    -> Width * Height;

% Area function of a triangle:
area({triangle, {dim, Base, Height}})
    when Base > 0    andalso Height  > 0
    -> Base * Height * 0.5;

% Area function of a ellipse:
area({ellipse, {radius, Radius1, Radius2}})
    when Radius1 > 0 andalso Radius2 > 0
    -> math:pi() * Radius1 * Radius2.

% wrapper function to call shapesArea
shapesArea({shapes, LIST}) -> shapesArea({shapes, LIST}, 0).
% tail recursion function
shapesArea({shapes, []}, SUM) -> SUM;
shapesArea({shapes, [HEAD | TAIL]}, SUM) -> shapesArea({shapes, TAIL}, SUM + area(HEAD)).

squaresArea({shapes, LIST})   
    -> shapesArea(filterSquare({shapes, LIST})).

trianglesArea({shapes, LIST}) 
    -> shapesArea(filterTriangle({shapes, LIST})).

filterRectangle({shapes, LIST}) 
    -> {shapes, [FLIST || {rectangle,_}=FLIST <- LIST]}.

filterEllipse({shapes, LIST}) 
    -> {shapes, [FLIST || {ellipse,_}=FLIST <- LIST]}.

filterTriangle({shapes, LIST}) 
    -> {shapes, [FLIST || {ellipse,_}=FLIST <- LIST]}.

filterSquare({shapes, []}) -> {shapes, []}.
%filterSquare({shapes, [HEAD | TAIL]}) -> {shapes, []}.

%
filterCircle({shapes, []}) -> {shapes, []}.
%filterCircle({shapes, [HEAD | TAIL]}) -> {shapes, []}.

% Filter functions of Type1:
shapesFilter(rectangle) -> fun filterRectangle/1;
shapesFilter(ellipse)   -> fun filterEllipse/1;
shapesFilter(triangle)  -> fun filterTriangle/1.

% Filter functions of type2:
shapesFilter2(rectangle) -> shapesFilter(rectangle);
shapesFilter2(ellipse)   -> shapesFilter(ellipse);
shapesFilter2(triangle)  -> shapesFilter(triangle);
shapesFilter2(square)    -> fun filterSquare/1;
shapesFilter2(circle)    -> fun filterCircle/1.