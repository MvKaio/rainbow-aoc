solve :-
	% Reading from the input file
	File = "in.txt",
	read_file_to_string(File, Str, []),

	% Dividing the file into its sections
	re_split("\n\n", Str, SplitStr),
	maplist(trim, SplitStr, TrimStr),
	exclude(empty_string, TrimStr, SeedsNSections),
	SeedsNSections = [RawSeeds|RawSections],

	% Transforming each section into a list of mappings
	maplist(filter_section_titles, RawSections, StrSections),
	maplist(get_params_of_list, StrSections, Sections),

	% Getting the list of seeds as integers
	split_string(RawSeeds, ":", " ", [_|[StrSeeds]]),
	split_string(StrSeeds, " ", " ", ListSeeds),
	maplist(number_string, Seeds, ListSeeds),

	% Passing each seed through the mappings
	foldl(apply_mappings_to_list, Sections, Seeds, OutSeeds),

	% The answer is the minimum of this list
	min_list(OutSeeds, Min),
	write(Min).

trim(S, T) :- split_string(S, "", " ", [T]).
empty_string(S) :- re_match("^[\s\n]*$", S).

filter_section_titles(S, T) :-
	split_string(S, "\n", " ", [_|T1]),
	exclude(empty_string, T1, T).

range(_, 0, []) :- !.
range(Start, Len, R) :-
	Start2 is Start + 1,
	Len2 is Len - 1,
	range(Start2, Len2, R2),
	R = [Start|R2].

get_params(Str, [S1, S2, Len]) :-
	split_string(Str, " ", " ", Str2),
	maplist(number_string, Nums, Str2),
	Nums = [S1, S2, Len].

get_params_of_list([], []) :- !.
get_params_of_list([Str|T], [Out|T1]) :-
	get_params(Str, Out),
	get_params_of_list(T, T1).

get_key(In, Out, S2, S1, Len, RetCode) :-
	E1 is S1 + Len - 1,
	((S1 =< In, In =< E1) -> 
		Out is S2 + (In - S1),
		RetCode = true;
		Out is In,
		RetCode = false
	).

apply_mappings(In, Out, []) :- Out is In, !.
apply_mappings(In, Out, [[S2, S1, Len]|T]) :-
	get_key(In, Tmp, S2, S1, Len, RetCode),
	(RetCode = true ->
		Out is Tmp;
		apply_mappings(In, Out, T)
	).

apply_mappings_to_list(_, [], []) :- !.
apply_mappings_to_list(Mappings, [H|T], [H1|T1]) :-
	apply_mappings(H, H1, Mappings),
	apply_mappings_to_list(Mappings, T, T1).
