package com.young.thewildoasisrestfulapi.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


/**
 * desc:
 *
 * @author Young.
 */
@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "hello, Young";
    }

}
