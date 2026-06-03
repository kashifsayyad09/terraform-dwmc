-- ============================================================
--  TechSolver — SQLite Schema + Seed Data
--  Run once:  sqlite3 techsolver.db < schema.sql
--  Flask auto-init: init_db() in app.py calls this file
-- ============================================================

PRAGMA foreign_keys = ON;

-- ──────────────────────────────────────────────
-- 1. IT Roles
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roles (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    icon        TEXT    NOT NULL,
    title       TEXT    NOT NULL UNIQUE,
    description TEXT    NOT NULL,
    tags        TEXT    NOT NULL,   -- comma-separated list
    color       TEXT    NOT NULL,   -- CSS hex for card accent
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────
-- 2. Skill groups + skills
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS skill_groups (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS skills (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id   INTEGER NOT NULL REFERENCES skill_groups(id) ON DELETE CASCADE,
    name       TEXT    NOT NULL,
    percentage INTEGER NOT NULL CHECK(percentage BETWEEN 0 AND 100)
);

-- ──────────────────────────────────────────────
-- 3. Career listings
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS careers (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    role       TEXT    NOT NULL,
    salary     TEXT    NOT NULL,   -- e.g. "₹18–32 LPA"
    badge      TEXT    NOT NULL,   -- e.g. "Hot"
    level      TEXT    NOT NULL,   -- e.g. "Senior"
    sort_order INTEGER NOT NULL DEFAULT 0
);

-- ──────────────────────────────────────────────
-- 4. Stats (hero counters)
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS stats (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    value REAL    NOT NULL,
    label TEXT    NOT NULL
);

-- ──────────────────────────────────────────────
-- 5. Contact form submissions
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS contact_submissions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    email        TEXT    NOT NULL,
    interest     TEXT    NOT NULL,
    message      TEXT,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────
-- 6. Newsletter subscribers
-- ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    email        TEXT    NOT NULL UNIQUE,
    subscribed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  SEED DATA
-- ============================================================

-- Roles
INSERT OR IGNORE INTO roles (icon, title, description, tags, color) VALUES
('⚙️', 'DevOps Engineer',
 'Bridge dev and ops by automating CI/CD pipelines, container orchestration, and cloud infrastructure with speed and reliability.',
 'Docker,Kubernetes,Jenkins,Terraform,Git', '#00c8ff'),

('🛡️', 'Cybersecurity Analyst',
 'Defend digital assets against threats through penetration testing, threat intelligence, SIEM management, and zero-trust architecture.',
 'SIEM,Pentesting,SOC,Firewalls,OWASP', '#ff6b35'),

('☁️', 'Cloud Architect',
 'Design scalable, fault-tolerant cloud solutions on AWS, Azure, or GCP — optimizing for performance, cost, and compliance.',
 'AWS,Azure,GCP,IaC,Serverless', '#7b2ff7'),

('🤖', 'AI/ML Engineer',
 'Build intelligent systems with deep learning, NLP, and MLOps pipelines — turning raw data into production-ready models.',
 'Python,PyTorch,TensorFlow,MLOps,LLMs', '#00ff9d'),

('💻', 'Full Stack Developer',
 'End-to-end web application development spanning frontend UI to backend APIs, databases, and microservices architecture.',
 'React,Node.js,TypeScript,MongoDB,REST', '#ffd700'),

('📊', 'Data Engineer',
 'Design and maintain robust data pipelines, warehouses, and lakes — enabling analytics at petabyte scale.',
 'Spark,Kafka,Airflow,SQL,dbt', '#ff4fa3'),

('🔗', 'Network Engineer',
 'Architect, deploy, and troubleshoot complex network topologies including SD-WAN, VPNs, and enterprise switching/routing.',
 'Cisco,CCNA,BGP,MPLS,SDN', '#00c8ff'),

('🗄️', 'Database Administrator',
 'Manage, optimize, and secure relational and NoSQL databases ensuring high availability, performance, and data integrity.',
 'PostgreSQL,MySQL,Oracle,MongoDB,Redis', '#7b2ff7'),

('📱', 'Mobile Developer',
 'Create native and cross-platform mobile applications for iOS and Android with seamless UX and offline capabilities.',
 'Flutter,React Native,Swift,Kotlin,Firebase', '#ff6b35'),

('🔍', 'QA / Test Engineer',
 'Ensure software quality through automated testing frameworks, performance benchmarking, and regression test suites.',
 'Selenium,Cypress,JMeter,Postman,CI/CD', '#00ff9d'),

('🏗️', 'Solutions Architect',
 'Translate complex business requirements into robust technical architectures — from microservices to enterprise platforms.',
 'AWS SA,Design Patterns,Microservices,APIs', '#ffd700'),

('📡', 'Site Reliability Engineer',
 'Keep large-scale systems running at 99.99% uptime through observability, chaos engineering, and incident management.',
 'Prometheus,Grafana,PagerDuty,On-call,SLOs', '#ff4fa3');


-- Skill groups
INSERT OR IGNORE INTO skill_groups (id, title) VALUES
(1, '// DevOps & Cloud'),
(2, '// Security & Data');

-- Skills
INSERT OR IGNORE INTO skills (group_id, name, percentage) VALUES
(1, 'Kubernetes / Docker',   92),
(1, 'AWS / Azure / GCP',     88),
(1, 'Terraform / Ansible',   78),
(1, 'CI/CD Pipelines',       95),
(2, 'Penetration Testing',   72),
(2, 'SIEM / SOC Operations', 68),
(2, 'Apache Spark / Kafka',  80),
(2, 'Machine Learning / AI', 85);


-- Stats
INSERT OR IGNORE INTO stats (id, value, label) VALUES
(1, 4.2,  'Million IT Jobs (India)'),
(2, 25.0, '% Annual Growth'),
(3, 12.0, 'Specializations'),
(4, 3.5,  'Trillion $ Industry');


-- Careers
INSERT OR IGNORE INTO careers (role, salary, badge, level, sort_order) VALUES
('Senior DevOps Engineer',      '₹18–32 LPA', 'Hot',         'Senior',        1),
('Cloud Security Architect',    '₹25–45 LPA', 'High Demand', 'Lead',          2),
('AI/ML Engineer',              '₹15–28 LPA', 'Trending',    'Mid–Senior',    3),
('Full Stack Developer',        '₹8–20 LPA',  'Always Open', 'Junior–Senior', 4),
('Data Engineer',               '₹12–25 LPA', 'Growing',     'Mid–Senior',    5),
('Cybersecurity Analyst',       '₹6–18 LPA',  'Critical',    'Junior–Senior', 6),
('SRE / Platform Engineer',     '₹20–38 LPA', 'Premium',     'Senior',        7),
('Cloud Solutions Architect',   '₹22–50 LPA', 'Elite',       'Lead',          8);
