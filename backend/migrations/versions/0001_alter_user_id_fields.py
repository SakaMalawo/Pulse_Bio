from alembic import op

revision = '0001'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.execute('SET FOREIGN_KEY_CHECKS=0')
    
    # Drop foreign key constraints (ignore errors if they don't exist)
    try:
        op.execute('ALTER TABLE physical_activities DROP FOREIGN KEY physical_activities_ibfk_1')
    except:
        pass
    try:
        op.execute('ALTER TABLE meals DROP FOREIGN KEY meals_ibfk_1')
    except:
        pass
    try:
        op.execute('ALTER TABLE medication_reminders DROP FOREIGN KEY medication_reminders_ibfk_1')
    except:
        pass
    
    # Modify column types
    op.execute('ALTER TABLE users MODIFY COLUMN id VARCHAR(12) NOT NULL')
    op.execute('ALTER TABLE meals MODIFY COLUMN user_id VARCHAR(12) NOT NULL')
    op.execute('ALTER TABLE physical_activities MODIFY COLUMN user_id VARCHAR(12) NOT NULL')
    op.execute('ALTER TABLE medication_reminders MODIFY COLUMN user_id VARCHAR(12) NOT NULL')
    
    # Recreate foreign key constraints
    op.execute('ALTER TABLE physical_activities ADD CONSTRAINT physical_activities_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id)')
    op.execute('ALTER TABLE meals ADD CONSTRAINT meals_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id)')
    op.execute('ALTER TABLE medication_reminders ADD CONSTRAINT medication_reminders_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id)')
    
    op.execute('SET FOREIGN_KEY_CHECKS=1')


def downgrade():
    op.execute('SET FOREIGN_KEY_CHECKS=0')
    op.execute('ALTER TABLE medication_reminders MODIFY COLUMN user_id BIGINT NOT NULL')
    op.execute('ALTER TABLE physical_activities MODIFY COLUMN user_id BIGINT NOT NULL')
    op.execute('ALTER TABLE meals MODIFY COLUMN user_id BIGINT NOT NULL')
    op.execute('ALTER TABLE users MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT')
    op.execute('SET FOREIGN_KEY_CHECKS=1')
