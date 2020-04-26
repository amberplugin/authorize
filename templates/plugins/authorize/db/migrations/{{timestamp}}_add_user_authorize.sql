-- +micrate Up

ALTER TABLE users ADD COLUMN invitation_accepted_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN invitation_created_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN invitation_declined_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN invitation_sent_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN invited_by BIGINT NULL;
ALTER TABLE users ADD COLUMN invitation_token VARCHAR NULL;

ALTER TABLE users ADD COLUMN confirmation_token VARCHAR NULL;
ALTER TABLE users ADD COLUMN confirmed BOOL NULL;
ALTER TABLE users ADD COLUMN confirmed_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN confirmation_sent_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN unconfirmed_email VARCHAR NULL;

ALTER TABLE users ADD COLUMN sign_in_count INTEGER NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN current_sign_in_ip VARCHAR NULL;
ALTER TABLE users ADD COLUMN last_sign_in_ip VARCHAR NULL;
ALTER TABLE users ADD COLUMN current_sign_in_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN last_sign_in_at TIMESTAMP NULL;

ALTER TABLE users ADD COLUMN reset_password_token VARCHAR NULL;
ALTER TABLE users ADD COLUMN reset_password_sent_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN password_reset_in_progress BOOL NULL DEFAULT false;

ALTER TABLE users ADD COLUMN locked_at TIMESTAMP NULL;
ALTER TABLE users ADD COLUMN failed_attempts INTEGER NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN unlock_token VARCHAR NULL;

-- +micrate Down

ALTER TABLE users DROP COLUMN invitation_accepted_at;
ALTER TABLE users DROP COLUMN invitation_created_at ;
ALTER TABLE users DROP COLUMN invitation_declined_at ;
ALTER TABLE users DROP COLUMN invitation_sent_at ;
ALTER TABLE users DROP COLUMN invited_by ;
ALTER TABLE users DROP COLUMN invitation_token ;

ALTER TABLE users DROP COLUMN confirmation_token ;
ALTER TABLE users DROP COLUMN confirmed ;
ALTER TABLE users DROP COLUMN confirmed_at ;
ALTER TABLE users DROP COLUMN confirmation_sent_at ;
ALTER TABLE users DROP COLUMN unconfirmed_email ;

ALTER TABLE users DROP COLUMN sign_in_count ;
ALTER TABLE users DROP COLUMN current_sign_in_ip ;
ALTER TABLE users DROP COLUMN last_sign_in_ip ;
ALTER TABLE users DROP COLUMN current_sign_in_at ;
ALTER TABLE users DROP COLUMN last_sign_in_at ;

ALTER TABLE users DROP COLUMN reset_password_token ;
ALTER TABLE users DROP COLUMN reset_password_sent_at ;
ALTER TABLE users DROP COLUMN password_reset_in_progress ;

ALTER TABLE users DROP COLUMN locked_at ;
ALTER TABLE users DROP COLUMN failed_attempts ;
ALTER TABLE users DROP COLUMN unlock_token ;