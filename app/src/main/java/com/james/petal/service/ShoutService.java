package com.james.petal.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class ShoutService {
	
	private final RestTemplate restTemplate;
	
	public ShoutService(RestTemplateBuilder restTemplateBuilder) {
		this.restTemplate = restTemplateBuilder.build();
	}
	
	public String getShoutString(String input) {
		String shoutUrl = "http://api.shoutcloud.io/V1/SHOUT";
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		Map<String, Object> payload = new HashMap<String, Object>();
		payload.put("input", input);
		
		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);
		
		Map<String, Object> response = this.restTemplate.postForObject(shoutUrl, entity, Map.class);
		return (String) response.get("OUTPUT");
	}

}
