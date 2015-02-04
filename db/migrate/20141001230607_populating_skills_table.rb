class PopulatingSkillsTable < ActiveRecord::Migration
  def change
    Skill.create!(name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    Skill.create!(name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
    Skill.create(name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
    Skill.create(name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)
    Skill.create(name: 'Computer Networking', key_name: 'computer_networking', vpos: 4, hpos: 0)
    Skill.create(name: 'Data Security', key_name: 'data_security', vpos: 5, hpos: 0)
    Skill.create(name: 'Data Science', key_name: 'data_science', vpos: 6, hpos: 0)
    Skill.create(name: 'Web Development', key_name: 'web_dev', vpos: 7, hpos: 0)

    Skill.create(name: 'Database', key_name: 'dbms', vpos: 0, hpos: 1)
    Skill.create(name: 'Software Dev. Methodologies', key_name: 'soft_dev_methods', vpos: 1, hpos: 1)
    Skill.create(name: 'Management', key_name: 'management', vpos: 2, hpos: 1)
    Skill.create(name: 'Leadership', key_name: 'leadership', vpos: 3, hpos: 1)
    Skill.create(name: 'Communications', key_name: 'communications', vpos: 4, hpos: 1)
    Skill.create(name: 'Sales', key_name: 'sales', vpos: 5, hpos: 1)
    Skill.create(name: 'Hiring & Interviewing', key_name: 'hiring', vpos: 6, hpos: 1)
    Skill.create(name: 'Effective Presentations', key_name: 'presentations', vpos: 7, hpos: 1)

    Skill.create(name: 'Negotiation', key_name: 'negotiation', vpos: 0, hpos: 2)
    Skill.create(name: 'Strategy', key_name: 'strategy', vpos: 1, hpos: 2)
    Skill.create(name: 'Operations', key_name: 'ops', vpos: 2, hpos: 2)
    Skill.create(name: 'Project Management', key_name: 'pmp', vpos: 3, hpos: 2)
    Skill.create(name: 'Finance', key_name: 'finance', vpos: 4, hpos: 2)
    Skill.create(name: 'UX/UI', key_name: 'ux', vpos: 5, hpos: 2)
    Skill.create(name: 'Graphic Design', key_name: 'graphic_design', vpos: 6, hpos: 2)
    Skill.create(name: 'Product Management', key_name: 'product_management', vpos: 7, hpos: 2)
  end
end
