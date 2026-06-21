package com.example.backend.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // Keep your existing public endpoint open
                .requestMatchers("/api/ping", "/h2-console/**").permitAll()
                .anyRequest().authenticated()
            )
            .httpBasic()   // simple basic auth
            .and()
            .csrf().disable()               // ok for dev (enables Postman/H2 console)
            .headers().frameOptions().sameOrigin(); // needed for H2 console to display

        return http.build();
    }

    @Bean
    public UserDetailsService users() {
        // In-memory user: user / password
        UserDetails user = User.withDefaultPasswordEncoder()
                .username("user")
                .password("password")
                .roles("USER")
                .build();
        return new InMemoryUserDetailsManager(user);
    }
}