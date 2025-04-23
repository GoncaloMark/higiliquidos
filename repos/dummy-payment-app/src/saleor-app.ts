import { APL, FileAPL, SaleorCloudAPL, UpstashAPL} from "@saleor/app-sdk/APL";
import { RedisAPL} from "@saleor/app-sdk/APL/redis";
import { SaleorApp } from "@saleor/app-sdk/saleor-app";
import { createClient } from 'redis';
import { invariant } from "./lib/invariant";

/**
 * By default auth data are stored in the `.auth-data.json` (FileAPL).
 * For multi-tenant applications and deployments please use UpstashAPL.
 *
 * To read more about storing auth data, read the
 * [APL documentation](https://github.com/saleor/saleor-app-sdk/blob/main/docs/apl.md)
 */
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
		apl = new RedisAPL({
			client: createClient({
				url: process.env.REDIS_URL,
			}),
			hashCollectionKey: "payment_app_auth",
		})
  default:
    apl = new FileAPL({
      fileName: process.env.FILE_APL_PATH,
    });
}

export const saleorApp = new SaleorApp({
  apl,
});
