s.boot


p = ProxySpace.push()


~a[0] = {
	var sig1, sig2;
	sig1 = Pan2.ar(Gendy5.ar(minfreq: 50, maxfreq: 55), SinOsc.kr(1));
	sig2 = Pan2.ar(Gendy5.ar(minfreq: 45, maxfreq: 50), SinOsc.kr(1.5));
	sig1 + sig2;
}

~a[1] = \filterIn -> {|in| DFM1.ar(in, SinOsc.kr(0.1, mul: 1000, add: 1250), 1)}
~a[2] = \filterIn -> {|in| in * SinOsc.kr(0.9, mul: 0.5, add: 0.5)}
~a[3] = \filterIn -> {|in| NHHall.ar([in[0], in[1]], 0.1) + in}
~a.play