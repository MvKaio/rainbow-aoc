function solve()
	local file = io.open("in.txt", "r") 
	local blob = file:read("*all")
	local lines = split(blob, "\n")

	for i,line in ipairs(lines) do
		local hand = split(line, " ")[1]
		local value = split(line, " ")[2]
	end

	table.sort(lines, hand_ordering)

	local answer = 0
	for i,line in ipairs(lines) do
		local hand = split(line, " ")[1]
		local value = split(line, " ")[2]
		answer = answer + tonumber(value) * i
	end

	return answer
end

function strength(hand)
	local t = {}
	hand:gsub(".", function(c) table.insert(t, c) end)

	table.sort(t)

	-- Five of a Kind
	if 
		t[1] == t[2] and 
		t[2] == t[3] and
		t[3] == t[4] and
		t[4] == t[5]
	then
		return 6
	end

	-- Four of a Kind
	if 
		(t[1] == t[2] and 
		t[2] == t[3] and
		t[3] == t[4]) or
		(t[2] == t[3] and 
		t[3] == t[4] and
		t[4] == t[5])
	then
		return 5
	end

	-- Full House
	if 
		(t[1] == t[2] and t[4] == t[5]) and
		(t[2] == t[3] or t[3] == t[4])
	then
		return 4
	end

	-- Three of a kind
	if 
		(t[1] == t[2] and t[2] == t[3]) or
		(t[2] == t[3] and t[3] == t[4]) or
		(t[3] == t[4] and t[4] == t[5])
	then
		return 3
	end

	-- Two Pair
	if 
		(t[1] == t[2] and t[3] == t[4]) or
		(t[1] == t[2] and t[4] == t[5]) or
		(t[2] == t[3] and t[4] == t[5])
	then
		return 2
	end

	-- One Pair
	if 
		(t[1] == t[2]) or
		(t[2] == t[3]) or
		(t[3] == t[4]) or
		(t[4] == t[5])
	then
		return 1
	end

	-- High Card == Nothing
	return 0
end

function card_strength()
	local t = {
		["A"]=14, ["K"]=13, ["Q"]=12, ["J"]=11, ["T"]=10,
		["2"]=2, ["3"]=3, ["4"]=4, ["5"]=5,
		["6"]=6, ["7"]=7, ["8"]=8, ["9"]=9,
	}
	return t
end

function tiebreak(a, b)
	-- Returns 1 if a should come before b

	local ta = {}
	local tb = {}
	a:gsub(".", function(c) table.insert(ta, c) end)
	b:gsub(".", function(c) table.insert(tb, c) end)

	local t = card_strength()

	for i,_ in ipairs(ta) do
		if (t[ta[i]] == nil) then return false end
		if t[ta[i]] > t[tb[i]] then
			return false
		end
		if t[ta[i]] < t[tb[i]] then
			return true
		end
	end

	return true
end

function hand_ordering(a, b)
	local hand_a = split(a, " ")[1]
	local hand_b = split(b, " ")[1]

	local strength_a = strength(hand_a)
	local strength_b = strength(hand_b)

	if (strength_a == strength_b) then
		return tiebreak(a, b)
	else
		return strength_a < strength_b
	end
end

function split(str, sep)
	local t = {}
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, s)
	end
	return t
end
