if @profile
	json.extract! @profile, :id, :title, :employee_identifier
end

