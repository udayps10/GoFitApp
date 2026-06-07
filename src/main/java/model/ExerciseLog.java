package model;

import java.sql.Date;

public class ExerciseLog {
    private int id;
    private int userId;
    private String exerciseName;
    private double weightKg;
    private int reps;
    private Date logDate;

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public int getUserId()                  { return userId; }
    public void setUserId(int userId)       { this.userId = userId; }

    public String getExerciseName()                     { return exerciseName; }
    public void setExerciseName(String exerciseName)    { this.exerciseName = exerciseName; }

    public double getWeightKg()                 { return weightKg; }
    public void setWeightKg(double weightKg)    { this.weightKg = weightKg; }

    public int getReps()                { return reps; }
    public void setReps(int reps)       { this.reps = reps; }

    public Date getLogDate()            { return logDate; }
    public void setLogDate(Date logDate){ this.logDate = logDate; }
}