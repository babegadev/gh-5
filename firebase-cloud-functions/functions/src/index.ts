import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import axios from "axios";

admin.initializeApp();
const db = admin.firestore();

exports.addDocIdOnCreate = functions.firestore
    .document('user-stories/{docId}')
    .onCreate((snap, context) => {
        const docId = context.params.docId;
        const docRef = snap.ref;

        return docRef.update({ doc_id: docId })
            .then(() => {
                console.log(`Document ${docId} updated with its ID`);
            })
            .catch((error) => {
                console.error(`Error updating document ${docId}:`, error);
            });
    });

exports.fetchDocumentsByIds = functions.https.onRequest(async (req, res) => {
    try {
        const { ids } = req.body; // Assume the ids are sent in the request body
        if (!Array.isArray(ids)) {
            res.status(400).send('Invalid request: ids should be an array.');
            return;
        }

        const documents = [];
        for (const id of ids) {
            const doc = await db.collection('user-stories').doc(id).get();
            if (doc.exists) {
                documents.push({ id: doc.id, ...doc.data() });
            } else {
                documents.push({ id, error: 'Document not found' });
            }
        }

        res.status(200).send(documents);
    } catch (error) {
        console.error('Error fetching documents:', error);
        res.status(500).send('Internal Server Error');
    }
});


// Moderation function
export const moderateChatMessage = functions.firestore
    .document('chat_messages/{messageId}')
    .onCreate(async (snap, context) => {
        const data = snap.data();

        if (!data || !data.text) {
            return null;
        }

        const text = data.text;

        try {
            const response = await axios.post(
                'https://api.openai.com/v1/moderations',
                { input: text },
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer REDACTED`,
                    },
                }
            );

            const result = response.data.results[0];

            if (result.flagged) {
                const warningMessage = 'This message has been removed due to inappropriate content.';

                await snap.ref.update({ text: warningMessage });
            }
        } catch (error) {
            console.error('Error moderating message:', error);
        }

        return null;
    });

// List of questions
const questions = [
    "What are your hobbies and interests?",
    "Can you describe a memorable experience you've had?",
    "What are some goals you are currently working towards?",
    "What's your favorite book or movie and why?",
    "What are some skills you are trying to develop?",
    "Can you share something unique about yourself?",
    "What motivates you to get up in the morning?",
    "Who has had a significant impact on your life and how?",
    "What do you value most in your friendships?",
    "How do you like to spend your weekends?"
];

// Function to return a random question
exports.getGuidingQuestion = functions.https.onRequest((req, res) => {
    const randomIndex = Math.floor(Math.random() * questions.length);
    const question = questions[randomIndex];

    res.status(200).send({ question });
});