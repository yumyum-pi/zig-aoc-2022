YEAR=2022
DAY=1
PART=1

Build:
	zig cc -optimize=3 ./$(YEAR)/day$(DAY)/part$(PART).c -o build 
