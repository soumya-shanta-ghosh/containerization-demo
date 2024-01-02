package cloud.learneon.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class DemoController {
    @GetMapping(path = "say-hello")
    public String sayHello() {
        log.info("Inside sayHello() method of Containerization Demo Spring Boot Web Application");
        return "Hello from Spring Boot Web Application Containerization Demo";
    }
}
