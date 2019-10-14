(
Window.closeAll;
~buildRow = {
	|window|
	var window_width, row_view, row_width, button_view, button_width;
	window_width = window.bounds.width;
	window.view.decorator.nextLine();

	// the row will have a button_view and 2 knobs
	row_view = FlowView(window, Point(window_width, 50.0), 0@0, 0@0);
	row_view.background_(Color.rand);
	row_width = row_view.bounds.width;

	// make a button view to add the 3 rows of buttons to
	button_view = FlowView(row_view, Point(row_width * 0.9, 50.0), 0@0, 0@0);
	button_view.background_(Color.rand);
	button_width = button_view.bounds.width / 16;

	// add buttons to row
	16.do({
		|i|
		Button(button_view, Point(button_width, 15))
		.states_([
			["", Color.gray, Color.gray],
			["", Color.black, Color.white]
		])
		.action_({|button|
			button.value.postln;
		});
	});

	button_view.decorator.nextLine();
	16.do({
		|i|
		Slider(button_view, Point(button_width, 15));
	});

	button_view.decorator.nextLine();
	16.do({
		|i|
		Slider(button_view, Point(button_width, 15));
	});

	Knob(row_view, 40@40);
	Knob(row_view, 40@40);

};

w = Window.new("sequencer", Rect(0, 0, 1000, 500))
.front()
.alwaysOnTop_(true);

w.view.addFlowLayout;

~buildRow.value(w);
)

~buildRow.value(w);

w.view.addFlowLayout
w.view.decorator
