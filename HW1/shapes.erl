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
    when (Width>0) and (Height>0)
    -> Width * Height;

% Area function of a triangle:
area({triangle, {dim, Base, Height}})
    when (Base>0) and (Height>0)
    -> Base * Height * 0.5;

% Area function of a ellipse:
area({ellipse, {radius, Radius1, Radius2}})
    when (Radius1>0) and (Radius2>0)
    -> math:pi() * Radius1 * Radius2.

% wrapper function to call shapesArea
shapesArea({shapes, LIST}) -> shapesArea({shapes, LIST}, 0).
% tail recursion function
shapesArea({shapes, []}, SUM) -> SUM;
shapesArea({shapes, [HEAD | TAIL]}, SUM) 
    -> shapesArea({shapes, TAIL}, SUM + area(HEAD)).

squaresArea({shapes, LIST})   
    -> shapesArea({shapes,lists:filter(fun sqrFilter/1,LIST)}).

trianglesArea({shapes, LIST}) 
    -> shapesArea({shapes,lists:filter(fun triFilter/1,LIST)}).

recFilter({Type, {Dim, Width, Height}}) 
    when Width > 0 andalso Height > 0 
    andalso (
        (Type == rectangle andalso Dim == dim) 
        or (Type == triangle andalso Dim == dim) 
        or (Type == ellipse andalso Dim == radius)
    ) -> Type =:= rectangle.

triFilter({Type, {Dim, Width, Height}}) 
    when Width > 0 andalso Height > 0 
    andalso (
        (Type == rectangle andalso Dim == dim) 
        or (Type == triangle andalso Dim == dim) 
        or (Type == ellipse andalso Dim == radius)
    ) -> Type =:= triangle.

eliFilter({Type, {Radius, Radius1, Radius2}}) 
    when Radius1 > 0 andalso Radius2 > 0 
    andalso (
        (Type == rectangle andalso Radius == dim) 
        or (Type == triangle andalso Radius == dim) 
        or (Type == ellipse andalso Radius == radius)
    ) -> Type =:= ellipse.

circFilter({Type, {Radius, Radius1, Radius2}}) 
    when Radius1 > 0 andalso Radius2 > 0 
    andalso (
        (Type == rectangle andalso Radius == dim) 
        or (Type == triangle andalso Radius == dim) 
        or (Type == ellipse andalso Radius == radius)
    ) -> Type =:= ellipse andalso Radius1 =:= Radius2.

sqrFilter({Type, {Dim, Width, Height}}) 
    when Width > 0 andalso Height > 0 
    andalso (
        (Type == rectangle andalso Dim == dim) 
        or (Type == triangle andalso Dim == dim) 
        or (Type == ellipse andalso Dim == radius)
    ) -> Type =:= rectangle andalso Width =:= Height.

shapesFilter(rectangle) -> fun({shapes,LIST}) -> {shapes,lists:filter(fun recFilter/1,LIST)} end;
shapesFilter(triangle)  -> fun({shapes,LIST}) -> {shapes,lists:filter(fun triFilter/1,LIST)} end;
shapesFilter(ellipse)   -> fun({shapes,LIST}) -> {shapes,lists:filter(fun eliFilter/1,LIST)} end.

shapesFilter2(circle) -> fun({shapes,LIST}) -> {shapes,lists:filter(fun circFilter/1,LIST)} end;
shapesFilter2(square) -> fun({shapes,LIST}) -> {shapes,lists:filter(fun sqrFilter/1,LIST)} end;
shapesFilter2(Type)   -> shapesFilter(Type).