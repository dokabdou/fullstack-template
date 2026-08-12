package com.backend.backend.services.auth;

import com.backend.backend.dtos.auth.AuthDTO;
import com.backend.backend.dtos.auth.LoginDTO;
import com.backend.backend.dtos.auth.RegistrationDTO;
import com.backend.backend.entities.User;
import com.backend.backend.enums.RoleName;
import com.backend.backend.exceptions.BackendException;
import com.backend.backend.exceptions.UserAlreadyExistsException;
import com.backend.backend.exceptions.auth.InvalidCredentialsException;
import com.backend.backend.repositories.RoleRepository;
import com.backend.backend.repositories.UserRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;

    public AuthService(AuthenticationManager authenticationManager,
                       UserRepository userRepository,
                       RoleRepository roleRepository,
                       PasswordEncoder passwordEncoder,
                       JwtService jwtService,
                       CustomUserDetailsService userDetailsService) {
        this.authenticationManager = authenticationManager;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
    }

    public void register(RegistrationDTO request) {
        if (userRepository.findByEmail(request.email()).isPresent()) {
            throw new UserAlreadyExistsException(request.email());
        }

        User user = new User(
                request.firstname(),
                request.lastname(),
                request.birthdate(),
                request.email(),
                passwordEncoder.encode(request.password()),
				request.createdAt(),
				request.updatedAt(),
                List.of(roleRepository.findByName(RoleName.USER)
                        .orElseThrow(() -> new BackendException("Should never happened")))
        );
        userRepository.save(user);
    }

    public AuthDTO login(LoginDTO request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.email(), request.password())
            );
        } catch (AuthenticationException e) {
            throw new InvalidCredentialsException(e.getMessage());
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.email());
        String token = jwtService.generateToken(userDetails);

		User user = userRepository.findByEmail(request.email())
				.orElseThrow(() -> new BackendException("Should never happened"));

        return new AuthDTO(token, "Bearer", jwtService.getExpirationMs(), user.getFirstname());
    }
}