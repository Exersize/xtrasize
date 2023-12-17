import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/heat_map.dart';
import 'package:flutter_application_1/data/workout_data.dart';
import 'package:provider/provider.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  void initState(){
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();

// create new workout
  void createNewWorkout(){
    showDialog(context: context,
     builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController
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
  // go to workouot page
  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(
      workoutName: workoutName),));
  }

  //save workout
  void save() {
    //get workout name
    String newWorkoutName = newWorkoutNameController.text;
    //add to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
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
    newWorkoutNameController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: const Text("Workout"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewWorkout,
        child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            //heatmap
            MyHeatMap(datasets: value.heatMapDataSet, startDateYYYYMMDD: value.getStartDate()),

            //workout list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () =>
                    goToWorkoutPage(value.getWorkoutList()[index].name),
              ),
          ),
        )
          ],
        ),
      ),
    );
  }
}