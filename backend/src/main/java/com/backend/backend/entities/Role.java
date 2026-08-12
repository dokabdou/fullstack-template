package com.backend.backend.entities;
import com.backend.backend.dtos.role.RoleDTO;
import com.backend.backend.enums.RoleName;
import com.backend.backend.utils.BaseEntity;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Entity
@Table(name = "roles")
@Getter
@Setter
public class Role extends BaseEntity<RoleDTO>  implements DtoConvertible<RoleDTO> {
    @NotNull
    @Column(name = "role_name")
    @Enumerated(EnumType.STRING)
    RoleName name;

    @ManyToMany(mappedBy = "roles")
    Set<User> attributedUsers;

    public Role(){}

    public Role(RoleName name){
        this.name = name;
    }

    @Override
    public RoleDTO toDTO() {
        return new RoleDTO(getId(),name);
    }
}
