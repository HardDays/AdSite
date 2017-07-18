"use strict";
var RegisterCompanyModel = (function () {
    function RegisterUserModel(name, address, other_address, email, phone, worktime, description, links, c_type, sub_category) {
        this.name = name;
        this.address = address;
        this.other_address = other_address;
        this.email = email;
        this.phone = phone;
        this.worktime = worktime;
        this.description = description;
        this.links = links;
        this.c_type = c_type;
        this.sub_category = sub_category;
    }
    return RegisterCompanyModel;
}());
exports.RegisterCompanyModel = RegisterCompanyModel;
//# sourceMappingURL=register.user.model.js.map