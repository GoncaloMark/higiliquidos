import { TRPCError } from "@trpc/server";
import { middleware } from "../server";
import { saleorApp } from "@/saleor-app";
import { createLogger } from "@/lib/logger/logger";

/**
 * Perform APL token retrieval in middleware, required by every handler that connects to Saleor
 */
export const attachAppToken = middleware(async ({ ctx, next }) => {
	const logger = createLogger("attach-app-token-middleware");
	logger.debug("attachAppToken middleware called", { ctx });
	if (!ctx.saleorApiUrl) {
		logger.error("Missing saleorApiUrl in request", { ctx });
    throw new TRPCError({
      code: "BAD_REQUEST",
      message: "Missing saleorApiUrl in request",
    });
  }

  const authData = await saleorApp.apl.get(ctx.saleorApiUrl);
	logger.info("authData", { authData });

  if (!authData?.token) {
		logger.error("Missing authData.token", { authData });
    throw new TRPCError({
      code: "UNAUTHORIZED",
      message: "Missing auth data",
    });
  }

  return next({
    ctx: {
      authData,
      // TODO: Remove appToken
      appToken: authData.token,
    },
  });
});
