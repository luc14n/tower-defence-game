const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');

const app = express();
const PORT = 8000;
const dbPath = path.join(__dirname, 'app', 'data', 'database.db');

// Middleware
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'app')));

// Initialize SQLite Database
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});

// Helper Functions
const addScore = (player, numericScore, callback) => {
    const insertQuery = `
        INSERT INTO scores (player, score)
        VALUES (?, ?)
    `;
    db.run(insertQuery, [player, numericScore], function (err) {
        if (err) {
            console.error('Insert query error:', err.message);
            return callback(err);
        }

        const updateRankQuery = `
            WITH RankedScores AS (
                SELECT id, player, score,
                       RANK() OVER (ORDER BY score DESC, id ASC) AS rank
                FROM scores
            )
            UPDATE scores
            SET rank = (
                SELECT rank
                FROM RankedScores
                WHERE scores.id = RankedScores.id
            )
        `;
        db.run(updateRankQuery, [], (err) => {
            if (err) return callback(err);

            const pruneQuery = `
                DELETE FROM scores
                WHERE rank > 10
            `;
            db.run(pruneQuery, [], callback);
        });
    });
};

const fetchTopScores = (callback) => {
    const query = `SELECT rank, player, score FROM scores ORDER BY rank ASC LIMIT 10`;
    db.all(query, [], callback);
};

// Routes
app.post('/api/scores', (req, res) => {
    console.log('Request body:', req.body);
    const { player, score } = req.body;
    const numericScore = parseInt(score, 10);

    if (!player || isNaN(numericScore)) {
        return res.status(400).json({ error: 'Player name and a valid numeric score are required' });
    }

    if (!req.body.player || !req.body.score) {
        return res.status(400).send('Player name and score are required');
    }

    if (!player || !score) {
        return res.status(400).json({ error: 'Player name and score are required' });
    }

    addScore(player, numericScore, (err) => {
        if (err) {
            console.error('Error adding score:', err.message);
            return res.status(500).json({ error: 'Failed to add score' });
        }
        res.status(201).json({ message: 'Score added successfully' });
    });
});

app.get('/api/scores', (req, res) => {
    db.all('SELECT * FROM scores ORDER BY rank ASC', (err, rows) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).send([]);
        }
        res.json(rows);
    });
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'app', 'WebDefenseWorriors.html'));
});

// Start Server
app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});