import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/subscription_enums.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('Loading...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text('Error: $message')),
          loaded: (subscription) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Plan',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subscription.tier == SubscriptionTier.premium
                                  ? 'Premium'
                                  : 'Free',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (subscription.status == SubscriptionStatus.active)
                              TextButton(
                                onPressed: () {
                                  context.read<SubscriptionBloc>().add(
                                    const SubscriptionEvent.cancelled(),
                                  );
                                },
                                child: const Text('Cancel'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${subscription.status == SubscriptionStatus.active ? 'Active' : 'Cancelled'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expires: ${subscription.endDate.toLocal().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (subscription.tier == SubscriptionTier.free)
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionBloc>().add(
                        const SubscriptionEvent.upgraded(),
                      );
                    },
                    child: const Text('Upgrade to Premium'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
