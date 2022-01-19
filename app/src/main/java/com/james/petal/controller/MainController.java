package com.james.petal.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.james.petal.service.ShoutService;

@RestController
@RequestMapping("/v1")
public class MainController {
	
	protected Gson gson = new Gson();
	
	@Autowired
	private ShoutService shoutService;

	@RequestMapping(value = "/demo", method = RequestMethod.POST, produces = "application/json", consumes = "application/json" )
	public ResponseEntity<Map<String, String>> reverseString(@RequestBody Map<String, String> payload) {
		String value = payload.get("data");

		String newValue = "";
		for (int i = value.length() - 1; i >= 0; i--) {
			newValue = newValue + value.charAt(i);
		}
		
		String test = shoutService.getShoutString(newValue);
		System.out.println(test);
		
		Map<String, String> response = new HashMap<String, String>();
		response.put("data", test);
		return new ResponseEntity<>(response, HttpStatus.OK);
	}

	@RequestMapping(value = "/sample", method = RequestMethod.GET)
	public String sample() {
		System.out.println("Sample endpoint hit");
		return "Sample Response";
	}

}
