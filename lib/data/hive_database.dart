import 'package:flutter_application_1/datetime/date_time.dart';
import 'package:flutter_application_1/models/exercise.dart';
import 'package:flutter_application_1/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase{

  //reference our hive box
  final _myBox = Hive.box("workout_database1");

  //check if already data base stored, if not , record the stard date
  bool previousDataExists(){
    if (_myBox.isEmpty){
      print("previous data does Not exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }

  //return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout into string so we can save to hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);



    if(exerciseCompleted(workouts)){
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    }else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISE", exerciseList);
  }

  //read data, and return list workout
  List<Workout> readFromDatabase(){
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    
    for (int i = 0; i < workoutNames.length; i++) {

      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length;j++) {

        exercisesInEachWorkout.add (
          Exercise(
            name: exerciseDetails[i][j][0], 
            weight: exerciseDetails[i][j][1], 
            reps: exerciseDetails[i][j][2], 
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
            ),
        );
      }

      //create individual workout
      Workout workout = 
        Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

        //add to overall list
        mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  //check if any exersices have been done

  bool exerciseCompleted(List<Workout> workouts) {

    for (var workout in workouts) {

      for(var exercise in workout.exercises) {
        if(exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given date by yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    //return 0 or 1 , if null then 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_ $yyyymmdd") ?? 0;
    return completionStatus;
  }
}

 //converts workout object
 List<String> convertObjectToWorkoutList(List<Workout>workouts) {
  List<String> workoutList = [

  ];

  for (int i = 0; i < workouts.length; i++) {
    //in each workout, add the names followed by list of exercise
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
 }

  //convert the exercise in a workout object into list of string
  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts){
    List<List<List<String>>> exerciseList= [
      /*

        [

          upperbody
          [ [biceps, 10kg, 10reps, 3sets], [triceps, 10kg, 10reps, 3sets] ],

          Lower body
          [ [Squats, 20kg, 10reps, 3sets], [calf, 10kg, 10reps, 3sets] ],


        ]
        */
    ];

    //go through each workout
    for(int i = 0; i < workouts.length; i++) {
      List<Exercise> exercisesInWorkout = workouts[i].exercises;

      List<List<String>> individualWorkout = [

      ];

      for (int j = 0; j < exercisesInWorkout.length; j++){
        List<String> individualExercise = [

        ];

        individualExercise.addAll(
          [
            exercisesInWorkout[j].name,
            exercisesInWorkout[j].weight,
            exercisesInWorkout[j].reps,
            exercisesInWorkout[j].sets,
            exercisesInWorkout[j].isCompleted.toString(),
          ],
        );
        individualWorkout.add(individualExercise);
      }

      exerciseList.add(individualWorkout);
    }

    return exerciseList;


  }