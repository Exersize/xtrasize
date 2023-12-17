import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/hive_database.dart';
import 'package:flutter_application_1/datetime/date_time.dart';
import 'package:flutter_application_1/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier{

  final db = HiveDatabase();


  List<Workout> workoutList = [
    Workout(
      name: "Upper Body", 
      exercises: [
        Exercise(
          name: "Bicep Curls", 
          weight: "9", 
          reps: "10", 
          sets: "3"
        )
      ]
    ),
    Workout(
      name: "Lower Body", 
      exercises: [
        Exercise(
          name: "Squad Curls", 
          weight: "10", 
          reps: "10", 
          sets: "3"
        )
      ]
    ),
  ];

  //if there is workout in database use it if not then use default
  void initializeWorkoutList(){
    if (db.previousDataExists()){
      workoutList = db.readFromDatabase();
    }else {
      db.saveToDatabase(workoutList);
    }

    //load heatmap
    loadHeatMap();
  }

  //get list workout
  List<Workout> getWorkoutList(){
    return workoutList;
  }

  //get length of a given workout
  int numberOfExercisesInWorkout (String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }


  // add a workout
  void addWorkout(String name){
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
 
  }
  //add an exercise to workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){
  //find the relevan workout  
  Workout relevantWorkout = getRelevantWorkout(workoutName);

  relevantWorkout.exercises.add(Exercise(
    name: exerciseName, 
    weight: weight, 
    reps: reps, 
    sets: sets
    )
    );

  notifyListeners();
  //save to database
    db.saveToDatabase(workoutList);
    

  }
  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName){
    //find the relevant workout and exercise
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check of boolean to show completed exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heatmap
    loadHeatMap();
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName){
    Workout relevantWorkout =
     workoutList.firstWhere((workout) => workout.name == workoutName);

     return relevantWorkout;
  }

  //return relevent exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //find the relevant exercise
    Exercise relevantExercise = relevantWorkout.exercises
    .firstWhere((exercise) => exercise.name == exerciseName);
    
    return relevantExercise;
  }

  //get start date
  String getStartDate(){
    return db.getStartDate();

  }

  Map<DateTime,int> heatMapDataSet = {};

  void loadHeatMap(){
    DateTime startDate = createDateTimeObject(getStartDate());

    //count number days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //completion status
    for(int i = 0; i < daysInBetween + 1; i++){
      String yyyymmdd = 
        convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int> {
        DateTime(year, month, day): completionStatus
      };
      // add to heatmap dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}