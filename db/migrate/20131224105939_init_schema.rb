class InitSchema < ActiveRecord::Migration
  def up

    create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "file"
      t.integer  "page_id"
      t.string   "identifier"
      t.integer  "lock_version", default: 0
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.integer  "creator_id",               null: false
      t.index ["creator_id"], name: "index_images_on_creator_id", using: :btree
      t.index ["page_id"], name: "index_images_on_page_id", using: :btree
    end

    create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "title"
      t.string   "navigation_title"
      t.text     "content",          limit: 65535
      t.text     "notes",            limit: 65535
      t.boolean  "system",                         default: false
      t.integer  "lock_version",                   default: 0,     null: false
      t.datetime "created_at",                                     null: false
      t.datetime "updated_at",                                     null: false
      t.integer  "parent_id"
      t.integer  "position",                       default: 1,     null: false
      t.text     "lead",             limit: 65535
      t.integer  "creator_id",                                     null: false
      t.index ["creator_id"], name: "index_pages_on_creator_id", using: :btree
    end

    create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name"
      t.string   "resource_type"
      t.integer  "resource_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
      t.index ["name"], name: "index_roles_on_name", using: :btree
    end

    create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                   limit: 100
      t.string   "email"
      t.string   "encrypted_password"
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                        default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.integer  "failed_attempts",                      default: 0, null: false
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "avatar"
      t.integer  "lock_version",                         default: 0
      t.text     "about",                  limit: 65535
      t.string   "curriculum_vitae"
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
      t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
      t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
      t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
    end

    create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "user_id"
      t.integer "role_id"
      t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
    end

    create_table "version_associations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "version_id"
      t.string  "foreign_key_name", null: false
      t.integer "foreign_key_id"
      t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
      t.index ["version_id"], name: "index_version_associations_on_version_id", using: :btree
    end

    create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "item_type",                       null: false
      t.integer  "item_id",                         null: false
      t.string   "event",                           null: false
      t.string   "whodunnit"
      t.text     "object",         limit: 16777215
      t.datetime "created_at"
      t.text     "object_changes", limit: 65535
      t.integer  "transaction_id"
      t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
      t.index ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree
    end

    add_foreign_key "images", "users", column: "creator_id", name: "index_images_on_creator_id"
    add_foreign_key "pages", "users", column: "creator_id", name: "index_pages_on_creator_id"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
