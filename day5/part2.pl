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
	maplist(merge_sort, Sections, SortedSections),

	% Getting the list of seeds as integers
	split_string(RawSeeds, ":", " ", [_|[StrSeeds]]),
	split_string(StrSeeds, " ", " ", ListSeeds),
	maplist(number_string, Seeds, ListSeeds),

	% Getting the seed intervals
	get_seed_intervals(Seeds, SeedIntervals),

	% Process each interval and find its minimum seed
	process_mappings_and_intervals(SortedSections, SeedIntervals, Min),
	write(Min).

trim(S, T) :- split_string(S, "", " ", [T]).
empty_string(S) :- re_match("^[\s\n]*$", S).

filter_section_titles(S, T) :-
	split_string(S, "\n", " ", [_|T1]),
	exclude(empty_string, T1, T).

%%%%% Functions to sort the mappings by its start 
merge([], L, L) :- !.
merge(L, [], L) :- !.
merge([H1|T1], [H2|T2], [H|T]) :-
	H1 = [_, Start1, _],
	H2 = [_, Start2, _],
	(Start1 =< Start2 ->
		H = H1,
		merge(T1, [H2|T2], T);
		H = H2,
		merge([H1|T1], T2, T)
	).

halve([], [], []).
halve([H], [H], []).  halve([H1|[H2|T]], [H1|TH1], [H2|TH2]) :- halve(T, TH1, TH2).

merge_sort([], []) :- !.
merge_sort([H], [H]) :- !.
merge_sort(In, Out) :- 
	halve(In, H1, H2),
	merge_sort(H1, SortedH1),
	merge_sort(H2, SortedH2),
	merge(SortedH1, SortedH2, Out), !.
%%%%% End of sorting functions

get_seed_intervals([], []).
get_seed_intervals([H1|[H2|T]], [[[H1, H1, H2]]|TT]) :-
	get_seed_intervals(T, TT).

update_interval_part([MTo, MStart, MLen], [To, Start, Len], OutInterval, L1) :-
	MEnd is MStart + MLen - 1,
	End is To + Len - 1,
	% Beginning of the interval
	(To < MStart ->
		InSLen is min(Len, MStart - To),
		IntervalStart = [[To, Start, InSLen]];
		IntervalStart = []
	),
	% Middle (intersection)
	InterStart is max(To, MStart),
	InterEnd is min(End, MEnd),
	InMStart is Start + (InterStart - To),
	InMLen is InterEnd + 1 - InterStart,
	(InterStart =< InterEnd ->
		InMTo is MTo + (InterStart - MStart),
		IntervalMiddle = [[InMTo,
						   InMStart,
						   InMLen]];
		IntervalMiddle = []
	),
	append(IntervalStart, IntervalMiddle, OutInterval),
	L1 is max(Start, InMStart + InMLen).

update_interval_part_all_mappings([], I, [I]) :- !.
update_interval_part_all_mappings([M|T], I, Out) :-
	update_interval_part(M, I, H, NextStart),
	I = [To, Start, Len],
	(NextStart < Start + Len ->
		NextTo is To + (NextStart - Start),
		NextLen is Len - (NextStart - Start),
		update_interval_part_all_mappings(T, [NextTo, NextStart, NextLen], Tail),
		append(H, Tail, Out);
		% else:
		Out = H
	).

update_interval(_, [], []) :- !.
update_interval(Mappings, [IntPart|T], NewInterval) :-
	update_interval_part_all_mappings(Mappings, IntPart, Head),
	update_interval(Mappings, T, Tail),
	append(Head, Tail, NewInterval).

get_min_of_interval([[H, _, _]], H).
get_min_of_interval([[H, _, _]|T], Min) :-
	get_min_of_interval(T, TailMin),
	Min is min(H, TailMin).

process_mappings_and_intervals(_, [], Min) :- Min is 0x3f3f3f3f3f3f3f3f, !.
process_mappings_and_intervals(Sections, [Interval|T], Min) :-
	foldl(update_interval, Sections, Interval, NewInterval),
	get_min_of_interval(NewInterval, IntervalMin),
	process_mappings_and_intervals(Sections, T, TailMin),
	Min is min(IntervalMin, TailMin), !.

get_params(Str, [S1, S2, Len]) :-
	split_string(Str, " ", " ", Str2),
	maplist(number_string, Nums, Str2),
	Nums = [S1, S2, Len].

get_params_of_list([], []) :- !.
get_params_of_list([Str|T], [Out|T1]) :-
	get_params(Str, Out),
	get_params_of_list(T, T1).
