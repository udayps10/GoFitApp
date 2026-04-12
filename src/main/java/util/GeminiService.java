package util;

import java.io.*;
import java.net.*;

public class GeminiService {
	// Replace this with your actual key if the one below is deactivated
	private static final String API_KEY = "AIzaSyCAgkvMddM_xPIk5BDBITgpxXXKWZElAKo";
	// Change gemini-1.5-flash to gemini-3-flash-preview
	private static final String URL_STR = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key="
			+ API_KEY;

	public static void main(String[] args) {
		try {
			GeminiService service = new GeminiService();
			System.out.println("Connecting to Gemini API...");
			String result = service.getDietPlan("fat loss");
			System.out.println("\n--- API RESPONSE ---\n" + result);
		} catch (Exception e) {
			System.err.println("Error occurred during API call:");
			e.printStackTrace();
		}
	}

	public String getDietPlan(String userGoal) throws Exception {
		URL url = new URL(URL_STR);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		conn.setDoOutput(true);

		// Fixed JSON format - perfectly escaped for Java strings
		String jsonInput = "{\"contents\":[{\"parts\":[{\"text\":\"Give me a diet plan for " + userGoal + "\"}]}]}";

		try (OutputStream os = conn.getOutputStream()) {
			byte[] input = jsonInput.getBytes("utf-8");
			os.write(input, 0, input.length);
		}

		int responseCode = conn.getResponseCode();

		// Use ErrorStream if response code is 400+ to see the ACTUAL error message
		InputStream is = (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream();

		if (is == null)
			return "Error: No response stream available. Code: " + responseCode;

		BufferedReader br = new BufferedReader(new InputStreamReader(is, "utf-8"));
		StringBuilder response = new StringBuilder();
		String line;
		while ((line = br.readLine()) != null) {
			response.append(line.trim());
		}

		return response.toString();
	}
}