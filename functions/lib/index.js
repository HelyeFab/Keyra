"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.initializeExistingUsersSubscriptions = exports.handleUserCreated = void 0;
const https_1 = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const uuid_1 = require("uuid");
admin.initializeApp();
const functionConfig = {
    cpu: 1,
    memory: '512MiB',
    region: 'us-central1'
};
// Create a free subscription when a new user signs up
exports.handleUserCreated = (0, https_1.onRequest)(functionConfig, async (req, res) => {
    var _a;
    const user = (_a = req.body) === null || _a === void 0 ? void 0 : _a.user;
    if (!(user === null || user === void 0 ? void 0 : user.uid)) {
        console.error('No user data provided');
        res.status(400).send('No user data provided');
        return;
    }
    const db = admin.firestore();
    try {
        // Check if user already has a subscription
        const existingSubscriptions = await db
            .collection('subscriptions')
            .where('userId', '==', user.uid)
            .limit(1)
            .get();
        if (!existingSubscriptions.empty) {
            console.log(`User ${user.uid} already has a subscription`);
            res.status(200).send('User already has a subscription');
            return;
        }
        // Create a new free subscription
        const subscriptionData = {
            id: (0, uuid_1.v4)(),
            userId: user.uid,
            tier: 'free',
            status: 'active',
            startDate: admin.firestore.FieldValue.serverTimestamp(),
            endDate: new Date(Date.now() + 1000 * 60 * 60 * 24 * 365 * 100),
            autoRenew: true,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        await db.collection('subscriptions').doc(subscriptionData.id).set(subscriptionData);
        console.log(`Created free subscription for user ${user.uid}`);
        res.status(200).send('Subscription created successfully');
    }
    catch (error) {
        console.error('Error creating subscription:', error);
        res.status(500).send('Error creating subscription');
    }
});
// One-time function to create free subscriptions for existing users
exports.initializeExistingUsersSubscriptions = (0, https_1.onRequest)(Object.assign(Object.assign({}, functionConfig), { memory: '1GiB', timeoutSeconds: 540 }), async (req, res) => {
    // This should be called with appropriate authentication
    if (req.method !== 'POST') {
        res.status(405).send('Method Not Allowed');
        return;
    }
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith('Bearer ')) {
        res.status(401).send('Unauthorized');
        return;
    }
    try {
        // Verify the token
        const token = auth.split('Bearer ')[1];
        const decodedToken = await admin.auth().verifyIdToken(token);
        // Check if the user has admin claim
        if (!decodedToken.admin) {
            res.status(403).send('Forbidden: Requires admin privileges');
            return;
        }
        const db = admin.firestore();
        // Get all users
        const userRecords = await admin.auth().listUsers();
        // Process each user
        const batch = db.batch();
        let batchCount = 0;
        const batchArray = [batch];
        for (const user of userRecords.users) {
            // Check if user already has a subscription
            const existingSubscriptions = await db
                .collection('subscriptions')
                .where('userId', '==', user.uid)
                .limit(1)
                .get();
            if (!existingSubscriptions.empty) {
                console.log(`Skipping user ${user.uid} - already has subscription`);
                continue;
            }
            // Create subscription document
            const subscriptionData = {
                id: (0, uuid_1.v4)(),
                userId: user.uid,
                tier: 'free',
                status: 'active',
                startDate: admin.firestore.FieldValue.serverTimestamp(),
                endDate: new Date(Date.now() + 1000 * 60 * 60 * 24 * 365 * 100),
                autoRenew: true,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
            };
            const currentBatch = batchArray[batchArray.length - 1];
            currentBatch.set(db.collection('subscriptions').doc(subscriptionData.id), subscriptionData);
            batchCount++;
            // Firestore batches are limited to 500 operations
            if (batchCount === 499) {
                batchArray.push(db.batch());
                batchCount = 0;
            }
        }
        // Commit all batches
        await Promise.all(batchArray.map(batch => batch.commit()));
        res.status(200).json({
            message: 'Successfully initialized subscriptions for existing users',
            processedUsers: userRecords.users.length,
        });
    }
    catch (error) {
        console.error('Error initializing subscriptions:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
//# sourceMappingURL=index.js.map