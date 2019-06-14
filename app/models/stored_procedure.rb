class Stored_procedure < ActiveRecord::Base

  def self.fetch_db_records(proc_name_with_parameters)
    connection.select_all(proc_name_with_parameters)
  end

  def self.insert_update_delete_calculate(proc_name_with_parameters)
    connection.execute(proc_name_with_parameters)
  end

  def self.fetch_val_from_sp(proc_name_with_parameters)
    connection.select_value(proc_name_with_parameters)
  end

end
