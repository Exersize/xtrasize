import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/exercise_tile.dart';
import 'package:flutter_application_1/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  //checkbox was tapped
  void onCheckBoxChanged(String workuotName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false)
      .checkOffExercise(workuotName, exerciseName);
  }

  //text controller
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  
  //create new exercise
  void createNewExercise(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Add a new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          //exercise name
          TextField(
            controller: exerciseNameController,
          ),

          //weight
          TextField(
            controller: weightController,
          ),

          //reps
          TextField(
            controller: repsController,
          ),

          //sets
          TextField(
            controller: setsController,
          ),
        ],
        ),
        actions: [
          //save
          MaterialButton(
            onPressed: save,
            child: Text("save"),
            ),

          //close
          MaterialButton(
            onPressed: close,
            child: Text("close"),
            ),
        ],
      ),
      );
  }
  //save workout
  void save() {
    //get exercise name
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    //add to workout 
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName, 
      newExerciseName, 
      weight, 
      reps, 
      sets);
    //pop dialog
    Navigator.pop(context);
    clear();
  }

  //close
  void close() {
    //pop dialog
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add), 
          ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .name,
            weight: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .weight,
            reps: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .reps, 
            sets: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .sets, 
            isCompleted: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .isCompleted,
              onCheckBoxChanged:(val) => onCheckBoxChanged(
                widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name
              ),
              )
        ),
      ),
    );
  }
}