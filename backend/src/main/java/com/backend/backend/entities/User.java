package com.backend.backend.entities;

import com.backend.backend.dtos.user.UserDTO;
import com.backend.backend.utils.BaseEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@ToString
public class User extends BaseEntity<UserDTO> implements DtoConvertible<UserDTO> {
    @NotNull
    String firstname;
    @NotNull
    String lastname;
    @NotNull
    String email;
    @Column(name = "password")
	@NotNull
	String password;
    LocalDate birthdate;

	
	@Column(name = "created_at")
	LocalDateTime createdAt;
	@Column(name = "updated_at")
	LocalDateTime updatedAt;

    @ManyToMany
    @JoinTable(
            name = "user_role",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    List<Role> roles = new ArrayList<>();

    public User(){}

    public User(String firstname, String lastname, LocalDate birthdate, String email, String password, LocalDateTime createdAt, LocalDateTime updatedAt, List<Role> roles){
        this.firstname = firstname;
        this.lastname = lastname;
        this.birthdate = birthdate;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;

        this.roles = roles;
    }

    @Override
    public UserDTO toDTO(){
        return new UserDTO(getId(),email, firstname,lastname,birthdate, createdAt, updatedAt, roles.stream().map(Role::toDTO).toList());
    }



}

