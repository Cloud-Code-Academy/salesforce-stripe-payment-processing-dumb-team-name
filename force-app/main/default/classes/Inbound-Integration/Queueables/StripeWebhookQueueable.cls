/**
 * @description For processing inbound webhook events asynchronously
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Stripe Inbound Integration
 */

public with sharing class StripeWebhookQueueable implements Queueable, Finalizer {
  IStripeWebhookStrategy strategy;
  String requestBody;
  Integer attemptCount;

  /**
   * @description Constructor for queueable implementation
   */
  public StripeWebhookQueueable(
    IStripeWebhookStrategy strategy,
    String requestBody
  ) {
    this.strategy = strategy;
    this.requestBody = requestBody;
    this.attemptCount = 1;
  }

  /**
   * @description Constructor for finalizer implementation
   */
  public StripeWebhookQueueable(
    IStripeWebhookStrategy strategy,
    String requestBody,
    Integer attemptCounter
  ) {
    {
      this.strategy = strategy;
      this.requestBody = requestBody;
      this.attemptCount = attemptCounter;
    }
  }

  /**
   * @description Queueable implementation
   */
  public void execute(QueueableContext qc) {
    String jobId = '' + qc.getJobId();
    Logger.info('Begin: executing queueable job: ' + jobId);

    System.attachFinalizer(
      new StripeWebhookQueueable(
        this.strategy,
        this.requestBody,
        this.attemptCount
      )
    );

    // If this throws, it will retry 5 times (see Finalizer)
    strategy.handle(requestBody);
    Logger.info('Completed: execution of job: ' + jobId);
  }

  /**
   * @description Finalizer implementation
   */
  public void execute(FinalizerContext ctx) {
    String parentJobId = '' + ctx.getAsyncApexJobId();
    Logger.info(
      'Begin: executing finalizer attached for queueable job: ' + parentJobId
    );

    if (ctx.getResult() == ParentJobResult.SUCCESS) {
      Logger.info(
        'Parent queueable job [' + parentJobId + '] completed successfully.'
      );
    } else {
      Logger.error(
        'Parent queueable job [' +
          parentJobId +
          '] failed due to unhandled exception: ' +
          ctx.getException().getMessage()
      );

      // Retry up to 5 attempts
      if (attemptCount < 5) {
        Integer nextAttempt = attemptCount + 1;
        Logger.info('Retrying attempt ' + nextAttempt + '...');
        String newJobId = System.enqueueJob(
          new StripeWebhookQueueable(
            this.strategy,
            this.requestBody,
            nextAttempt
          )
        );
        Logger.info('Enqueued new job: ' + newJobId);
      } else {
        Logger.error('Max attempts reached (5). No further retries.');
      }

      Logger.info('Completed: finalizer for job: ' + parentJobId);
    }
  }

  public class StripeWebhookQueueableException extends Exception {
  }
}
