n = NetAddr.new("127.0.0.1", 10000)
n.sendMsg("/hello", 2)

(
x = {|t_pulseL=0, t_pulseR=0, freq=50, pulse_fac=10, pulse_dec=0.01, fb=0, t_snL=0, t_snR=0, sn_freq=500, sn_dec=1, hhL=0, hhR=0, hh_freq=1000|
	var pulse, sn, hh;
	pulse = SinOscFB.ar(EnvGen.ar(Env.perc(attackTime: 0, releaseTime: pulse_dec), [t_pulseL, t_pulseR], freq* pulse_fac, freq), fb);
	sn = HenonN.ar(sn_freq) * EnvGen.ar(Env.perc(releaseTime: sn_dec), [t_snL, t_snR]);
	hh = HPF.ar(WhiteNoise.ar([hhL, hhR]), hh_freq);
	pulse + sn + hh;
}.play
)
x.free;

Pbindef(\test, \type, \set, \id, x.nodeID, \args, #[\t_pulseL, \t_pulseR, \freq, \pulse_fac, \pulse_dec, \fb, \imp_rateL, \imp_rateR, \t_snL, \t_snR, \sn_freq, \sn_dec, \hhL, \hhR, \hh_freq], \t_pulseL, Pbjorklund(3, 8, offset: 2), \t_pulseR, Pbjorklund(5,8), \dur, 1/8, \freq, Pseq([50, 45], inf), \pulse_fac, Prand([10, 50], inf), \pulse_dec, Pwhite(0, 0.1), \fb, Pbrown(hi: 2), \t_snL, Pbjorklund(7, 16, offset: 2), \t_snR, Pbjorklund(11, 16), \sn_freq, Prand([500, 600],inf), \sn_dec, 0.1, \hhL, Pbjorklund(4, 6), \hhR, Pbjorklund(5, 6), \hh_freq, Pwhite(1000, 5000), '/helo', Prand([1,3,5],inf), \netAddr, n).play


Event.addParentType(\set, (
	finish: {
		if(~netAddr.notNil) {
			currentEnvironment.keys.do {|key|
				if ("/".matchRegexp(key.asString)) {
					~netAddr.sendMsg(key.asString, currentEnvironment[key]);
				}
			}
		}
	}
));