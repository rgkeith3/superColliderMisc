(
Window.closeAll;
s.waitForBoot{
	var synth, multislider, win, xyslider;
	var counter = 0;
	var predicting = false;

	var xydata = FluidDataSet(s);
	var paramdata = FluidDataSet(s);

	var xybuf = Buffer.alloc(s, 2);
	var parambuf = Buffer.alloc(s, 10);

	var mlp = FluidMLPRegressor(s,
		[7],
		activation:FluidMLPRegressor.sigmoid,
		outputActivation:FluidMLPRegressor.sigmoid,
		maxIter: 1000,
		learnRate:0.1,
		batchSize:1,
		validation:0
	);

	win = Window("ChaosSynth", Rect(10, 10, 840, 320)).front;

	multislider = MultiSliderView(win,Rect(10, 10, 400, 300))
	.elasticMode_(1)
	.isFilled_(1)
	.action_({
		arg ms;
		parambuf.setn(0, ms.value);
	})
	.value_(0.5.dup(10));

	xyslider = Slider2D(win,Rect(420,10,300,300))
	.action_{
		arg view;
		xybuf.setn(0, [view.x, view.y]);

		if(predicting){
			mlp.predictPoint(xybuf, parambuf, {
				parambuf.getn(0, 10, {|pred|
					defer {
						multislider.value_(pred);
					};
				});
			});
		}
	};

	Button(win, Rect(730, 10, 100, 20))
	.states_([["Add points"]])
	.action_{
		var id = "pointer-%".format(counter);
		xydata.addPoint(id, xybuf);
		paramdata.addPoint(id, parambuf);

		counter = counter + 1;
	};

	Button(win, Rect(730, 30, 100, 20))
	.states_([["save data"]])
	.action_{
		xydata.write("/Users/greykeith/superCollider/flucoma_data_sets/nnxy.json");
		paramdata.write("/Users/greykeith/superCollider/flucoma_data_sets/nnparam.json");
	};

	Button(win, Rect(730, 50, 100, 20))
	.states_([["load data"]])
	.action_{
		xydata.read("/Users/greykeith/superCollider/flucoma_data_sets/nnxy.json");
		paramdata.read("/Users/greykeith/superCollider/flucoma_data_sets/nnparam.json");
	};


	Button(win, Rect(730, 70, 100, 20))
	.states_([["train"]])
	.action_{
		mlp.fit(xydata, paramdata, _.postln);
	};

	Button(win, Rect(730, 90, 100, 20))
	.states_([["save mlp"]])
	.action_{
		mlp.write("/Users/greykeith/superCollider/flucoma_data_sets/nnmlp.json");
	};

	Button(win, Rect(730, 110, 100, 20))
	.states_([["load mlp"]])
	.action_{
		mlp.read("/Users/greykeith/superCollider/flucoma_data_sets/nnmlp.json");
	};

	Button(win, Rect(730, 130, 100, 20))
	.states_([["not predicting"], ["predicting"]])
	.action_{|but|
		predicting = but.value.asBoolean;
	};

	s.sync;

	synth = {
		var val = FluidBufToKr.kr(parambuf);
		var osc1, osc2, feed1, feed2, base1=69, base2=69, base3 = 130, loud1, loud2;
		#feed2, feed1 = LocalIn.ar(2);

		loud1 = FluidLoudness.kr(feed1);
		loud2 = FluidLoudness.kr(feed2);

		osc1 = SinOsc.ar((((feed1 * val[0]) +  val[1]) * base1).midicps,mul:(val[2] * 50).dbamp).atan;
		osc1 = MoogFF.ar(osc1,(base3-(val[3]*(loud2.clip(-120,0)+120))).lag(128/44100).midicps,val[4]*3.5);

		osc2 = SinOsc.ar((((feed2 * val[5]) +  val[6]) * base2).midicps,mul: (val[7] * 50).dbamp).atan;
		osc2 = MoogFF.ar(osc2,(base3-(val[8]*(loud1.clip(-120,0)+120))).lag(128/44100).midicps,val[9]*3.5);

		Out.ar(0,LeakDC.ar([osc1,osc2],mul:0.1));
		LocalOut.ar([osc1,osc2]);
	}.play;
};
)

s.scope