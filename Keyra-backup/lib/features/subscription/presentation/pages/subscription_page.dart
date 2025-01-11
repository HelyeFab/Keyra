import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/subscription.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../widgets/subscription_card.dart';

class SubscriptionPage extends StatelessWidget {
  final String userId;

  const SubscriptionPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionBloc(
        repository: context.read(),
      )..add(LoadCurrentSubscription(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subscription'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                context.read<SubscriptionBloc>().add(LoadSubscriptionHistory(userId));
                // TODO: Navigate to history page
              },
            ),
          ],
        ),
        body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubscriptionError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is SubscriptionLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCurrentSubscription(context, state.subscription),
                    const SizedBox(height: 24),
                    const Text(
                      'Available Plans',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSubscriptionPlans(context, state.subscription),
                  ],
                ),
              );
            }

            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  Widget _buildCurrentSubscription(BuildContext context, Subscription subscription) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Subscription',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Plan: ${subscription.tier.toString().split('.').last}'),
            Text('Status: ${subscription.status.toString().split('.').last}'),
            Text('Valid until: ${subscription.endDate.toString().split(' ')[0]}'),
            if (subscription.status == SubscriptionStatus.active &&
                subscription.tier != SubscriptionTier.free)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<SubscriptionBloc>()
                        .add(CancelSubscription(subscription.id));
                  },
                  child: const Text('Cancel Subscription'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlans(BuildContext context, Subscription currentSub) {
    return Column(
      children: [
        SubscriptionCard(
          title: 'Premium',
          price: '\$4.99/month',
          features: const [
            'Access to all books',
            'Unlimited flashcards',
            'Ad-free experience',
          ],
          isCurrentPlan: currentSub.tier == SubscriptionTier.premium,
          onSubscribe: () {
            // TODO: Implement subscription upgrade logic
          },
        ),
        const SizedBox(height: 16),
        SubscriptionCard(
          title: 'Unlimited',
          price: '\$9.99/month',
          features: const [
            'Everything in Premium',
            'Early access to new books',
            'Personalized reading recommendations',
            'Priority support',
          ],
          isCurrentPlan: currentSub.tier == SubscriptionTier.unlimited,
          onSubscribe: () {
            // TODO: Implement subscription upgrade logic
          },
          isPremium: true,
        ),
      ],
    );
  }
}
