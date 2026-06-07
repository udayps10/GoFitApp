package model;

import java.sql.Date;

public class Calorie{
    private int id;
    private int userId;
    private String foodName;
    private String serving;
    private int kcal;
    private double carbsG;
    private double proteinG;
    private double fatG;
    private Date logDate;

    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }

    public int getUserId()                  { return userId; }
    public void setUserId(int userId)       { this.userId = userId; }

    public String getFoodName()                     { return foodName; }
    public void setFoodName(String foodName)        { this.foodName = foodName; }

    public String getServing()                  { return serving; }
    public void setServing(String serving)      { this.serving = serving; }

    public int getKcal()                { return kcal; }
    public void setKcal(int kcal)       { this.kcal = kcal; }

    public double getCarbsG()               { return carbsG; }
    public void setCarbsG(double carbsG)    { this.carbsG = carbsG; }

    public double getProteinG()                 { return proteinG; }
    public void setProteinG(double proteinG)    { this.proteinG = proteinG; }

    public double getFatG()             { return fatG; }
    public void setFatG(double fatG)    { this.fatG = fatG; }

    public Date getLogDate()                { return logDate; }
    public void setLogDate(Date logDate)    { this.logDate = logDate; }
}