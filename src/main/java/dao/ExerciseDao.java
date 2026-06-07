package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Excercise;
import util.DBConnection;

public class ExerciseDao {

    public List<Excercise> getAllExercises() {
        List<Excercise> exercises = new ArrayList<>();

        try (Connection con = DBConnection.getconnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM exercises")) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Excercise exercise = new Excercise();

                exercise.setId(rs.getInt("id"));
                exercise.setName(rs.getString("name"));
                exercise.setMuscleGroupId(rs.getInt("muscle_group_id"));
                exercise.setEquipmentId(rs.getInt("equipment_id"));

                exercises.add(exercise);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exercises;
    } 


}