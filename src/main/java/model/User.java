package model;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private int age;
    private double weightKg;
    private double heightCm;
    private String goal;

    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }

    public String getName()             { return name; }
    public void setName(String name)    { this.name = name; }

    public String getEmail()            { return email; }
    public void setEmail(String email)  { this.email = email; }

    public String getPassword()                  { return password; }
    public void setPassword(String password)     { this.password = password; }

    public int getAge()                 { return age; }
    public void setAge(int age)         { this.age = age; }

    public double getWeightKg()              { return weightKg; }
    public void setWeightKg(double weightKg) { this.weightKg = weightKg; }

    public double getHeightCm()              { return heightCm; }
    public void setHeightCm(double heightCm) { this.heightCm = heightCm; }

    public String getGoal()             { return goal; }
    public void setGoal(String goal)    { this.goal = goal; }
}