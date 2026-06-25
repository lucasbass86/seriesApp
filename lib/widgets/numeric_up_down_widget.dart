import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:seriesapp/utils/utils.dart';

class NumericUpDownWidget extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final double width;
  final double fontSize;
  final TextEditingController controller;
  final Function? onChange;
  const NumericUpDownWidget({
    super.key,
    this.minValue = 0,
    this.maxValue = 999,
    this.width = 100,
    this.fontSize = 25,
    required this.controller,
    this.onChange,
  });

  @override
  State<NumericUpDownWidget> createState() => _NumericUpDownWidgetState();
}

class _NumericUpDownWidgetState extends State<NumericUpDownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double arrowSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    // if (mounted) {
    //   widget.controller.dispose();
    // }
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Center(
        child: Container(
          width: widget.width,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Utils.naranjaClarito, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ScaleTransition(
                  scale: _animation,
                  child:
                  // TextFormField(
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: widget.fontSize),
                  //   decoration: const InputDecoration(
                  //     contentPadding: EdgeInsets.all(8),
                  //     border: InputBorder.none,
                  //     focusedBorder: InputBorder.none,
                  //     enabledBorder: InputBorder.none,
                  //     errorBorder: InputBorder.none,
                  //     disabledBorder: InputBorder.none,
                  //     focusedErrorBorder: InputBorder.none,
                  //   ),
                  //   controller: widget.controller,
                  //   keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                  //   inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  // ),
                  Text(
                    widget.controller.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSize),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(Icons.arrow_drop_up, size: arrowSize),
                      onTap: () {
                        int currentValue =
                            widget.controller.text != '' ? int.parse(widget.controller.text) : 0;
                        setState(() {
                          if (currentValue < widget.maxValue) {
                            currentValue++;
                          } else {
                            currentValue = 0;
                          }
                          widget.controller.text = (currentValue).toString();
                          _onChanged();
                        });
                        widget.onChange?.call(currentValue);
                      },
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(Icons.arrow_drop_down, size: arrowSize),
                      onTap: () {
                        int currentValue =
                            widget.controller.text != '' ? int.parse(widget.controller.text) : 0;
                        if (currentValue > widget.minValue) {
                          setState(() {
                            currentValue--;
                            widget.controller.text =
                                (currentValue > 0 ? currentValue : 0).toString();
                            _onChanged();
                          });
                        }
                        widget.onChange?.call(currentValue);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
