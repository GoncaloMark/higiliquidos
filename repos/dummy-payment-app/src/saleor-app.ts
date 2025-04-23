import { APL, FileAPL, SaleorCloudAPL, UpstashAPL} from "@saleor/app-sdk/APL";
import { RedisAPL} from "@saleor/app-sdk/APL/redis";
import { SaleorApp } from "@saleor/app-sdk/saleor-app";
import { createClient } from 'redis';
import { invariant } from "./lib/invariant";
import { createLogger } from "./lib/logger/create-logger";

/**
 * By default auth data are stored in the `.auth-data.json` (FileAPL).
 * For multi-tenant applications and deployments please use UpstashAPL.
 *
 * To read more about storing auth data, read the
 * [APL documentation](https://github.com/saleor/saleor-app-sdk/blob/main/docs/apl.md)
 */

const logger = createLogger("Create-Saleor-APP");

export let apl: APL;
switch (process.env.APL) {
  case "saleor-cloud":
    const token = process.env.REST_APL_TOKEN;
    const endpoint = process.env.REST_APL_ENDPOINT;

    invariant(token);
    invariant(endpoint);

    apl = new SaleorCloudAPL({ token, resourceUrl: endpoint });
    break;
  case "upstash":
    // Require `UPSTASH_URL` and `UPSTASH_TOKEN` environment variables
    apl = new UpstashAPL();
    break;
	case "redis":
        const redisClient = createClient({
            url: process.env.REDIS_URL,
        })
        redisClient.on('error', error => {
            logger.error(`Redis client error:`, error);
        });
        redisClient.on('connect', () => {
            logger.info(`Redis client connected`);
        });
        redisClient.on('ready', () => {
            logger.info(`Redis client ready`);
        });
        redisClient.on('end', () => {
            logger.info(`Redis client disconnected`);
        });
        redisClient.on('reconnecting', () => {
            logger.info(`Redis client reconnecting`);
        });

		apl = new RedisAPL({
			client: redisClient
		})
  default:
    apl = new FileAPL({
      fileName: process.env.FILE_APL_PATH,
    });
}

apl.isReady().then(() => {
    logger.info("APL is ready");
    }
).catch((error) => {
    logger.error("APL is not ready", error);
    process.exit(1);
});


export const saleorApp = new SaleorApp({
  apl,
});
