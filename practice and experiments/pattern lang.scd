'[1 1 r1 (0.1:1 0.2:4) (1 3)2 [1 2 3]4 w()2 b()4 bj(4,7)2 tm()i]3'
// separate by space
// r1 means Rest(1)
// () mean either prand or pwrand - if each item has a ratio, it's a pwrand, else prand
// [] means pseq
// w() means pwhite can take args
// b() means pbrown can take args
// bj() means pbjorklund can take args
// tm() means ptm can take args
// args ar separated by commas
// if no number after a subpattern, repeats once, else the number times, if 'i' is inf
// .seq(n) repeats n times, n default = inf
// resulting pattern:
Pseq([1,1,Rest(1), Pwrand([1, 4], [0.1, 0.2]), Prand([1,3], 2), Pseq([1,2,3], 4), Pwhite(length: 2), Pbrown(length: 4), Pbjorklund2(4, 7, 2), Ptm(length: inf)], 3)

"[1 1 r1 (0.1:1 0.2:4) (1 3)2 [1 2 3]4 w()2 b()4 bj(4,7)2 tm()i]3"

'[' => start a new entry in tree
// look for tokens in the stri
// [], (), w(), b(), bj(), tm()
s.kill

"12 23 4".split($ ).reduce({|a, b|
	a.postln;
	"next".postln;
	b.postln;
	1111;
}, "x")



"12 23 4".split($ ).size