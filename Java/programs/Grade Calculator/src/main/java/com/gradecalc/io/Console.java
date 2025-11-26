package com.gradecalc.io;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.util.Iterator;
import java.util.Map;

public class Console {

    public static void main(String[] args) {
        try {
            File file = new File("courses/PHYS 142.json");
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(file);

            Iterator<Map.Entry<String, JsonNode>> fields = rootNode.fields();



        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
