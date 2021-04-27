~a = {PlayBuf.ar(1, d[\samples][\sexual][0], loop: 1) * 0.5}
~a.stop

~ambiA = {FoaEncode.ar(~a.ar, FoaEncoderMatrix.newOmni)}

(~ambiMonitor = {
	var sig;
	sig = ~ambiA.ar;
	sig = FoaTransform.ar(sig, "pushX", m[\knob][0].kr.linlin(0,1,-pi/2, pi/2));
	FoaDecode.ar(sig, FoaDecoderMatrix.newQuad())}
)

~ambiMonitor.scope
~ambiMonitor.play