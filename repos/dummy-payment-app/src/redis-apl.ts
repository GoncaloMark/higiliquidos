import { SpanKind, SpanStatusCode } from "@opentelemetry/api";
import { SemanticAttributes } from "@opentelemetry/semantic-conventions";
import { APL, AplConfiguredResult, AplReadyResult, AuthData } from "@saleor/app-sdk/APL";
import { trace, Tracer } from "@opentelemetry/api";

import Redis from "ioredis";

const TRACER_NAME = "payments";

export const getOtelTracer = (): Tracer => trace.getTracer(TRACER_NAME, "1.0");

export const OTEL_CORE_SERVICE_NAME = "core";
export const OTEL_APL_SERVICE_NAME = "apps-cloud-apl";

/**
    * Configuration options for RedisAPL
*/
type RedisAPLConfig = {
    /** Redis client instance to use for storage */
    client: Redis;
    /** Optional key to use for the hash collection. Defaults to "saleor_app_auth" */
    hashCollectionKey?: string;
};

/**
    * Redis implementation of the Auth Persistence Layer (APL).
    * This class provides Redis-based storage for Saleor App authentication data.
*/
export class RedisAPL implements APL {
    private tracer = getOtelTracer();
    private client: Redis;
    private hashCollectionKey: string;

    constructor(config: RedisAPLConfig) {
        this.client = config.client;
        this.hashCollectionKey = config.hashCollectionKey || "saleor_app_auth";

        console.log("Redis APL initialized");
    }

    private async ensureConnection(): Promise<void> {
        if (this.client.status != 'ready') {
            console.log("Connecting to Redis...");
            await this.client.connect();
            console.log("Connected to Redis");
        }
    }

    async get(saleorApiUrl: string): Promise<AuthData | undefined> {
        await this.ensureConnection();

        console.log("Will get auth data from Redis for %s", saleorApiUrl);

        return this.tracer.startActiveSpan(
        "RedisAPL.get",
        {
            attributes: {
            saleorApiUrl,
            [SemanticAttributes.PEER_SERVICE]: OTEL_APL_SERVICE_NAME,
            },
            kind: SpanKind.CLIENT,
        },
        async (span: any) => {
            try {
            const authData = await this.client.hget(this.hashCollectionKey, saleorApiUrl);

            console.log("Received response from Redis");

            if (!authData) {
                console.log("AuthData is empty for %s", saleorApiUrl);
                span.setStatus({ code: SpanStatusCode.OK }).end();
                return undefined;
            }

            const parsedAuthData = JSON.parse(authData) as AuthData;
            span.setStatus({ code: SpanStatusCode.OK }).end();
            return parsedAuthData;
            } catch (e) {
            console.log("Failed to get auth data from Redis");
            console.log(e);

            span.recordException(e as Error);
            span
                .setStatus({
                code: SpanStatusCode.ERROR,
                message: "Failed to get auth data from Redis",
                })
                .end();

            throw e;
            }
        }
        );
    }

    async set(authData: AuthData): Promise<void> {
        await this.ensureConnection();

        console.log("Will set auth data in Redis for %s", authData.saleorApiUrl);

        return this.tracer.startActiveSpan(
        "RedisAPL.set",
        {
            attributes: {
            saleorApiUrl: authData.saleorApiUrl,
            appId: authData.appId,
            [SemanticAttributes.PEER_SERVICE]: OTEL_APL_SERVICE_NAME,
            },
            kind: SpanKind.CLIENT,
        },
        async (span: any) => {
            try {
            await this.client.hset(
                this.hashCollectionKey,
                authData.saleorApiUrl,
                JSON.stringify(authData)
            );

            console.log("Successfully set auth data in Redis");
            span.setStatus({ code: SpanStatusCode.OK }).end();
            } catch (e) {
            console.log("Failed to set auth data in Redis");
            console.log(e);

            span.recordException(e as Error);
            span
                .setStatus({
                code: SpanStatusCode.ERROR,
                message: "Failed to set auth data in Redis",
                })
                .end();

            throw e;
            }
        }
        );
    }

    async delete(saleorApiUrl: string): Promise<void> {
        await this.ensureConnection();

        console.log("Will delete auth data from Redis for %s", saleorApiUrl);

        return this.tracer.startActiveSpan(
        "RedisAPL.delete",
        {
            attributes: {
            saleorApiUrl,
            [SemanticAttributes.PEER_SERVICE]: OTEL_APL_SERVICE_NAME,
            },
            kind: SpanKind.CLIENT,
        },
        async (span: any) => {
            try {
            await this.client.hdel(this.hashCollectionKey , saleorApiUrl);

            console.log("Successfully deleted auth data from Redis");
            span.setStatus({ code: SpanStatusCode.OK }).end();
            } catch (e) {
            console.log("Failed to delete auth data from Redis");
            console.log(e);

            span.recordException(e as Error);
            span
                .setStatus({
                code: SpanStatusCode.ERROR,
                message: "Failed to delete auth data from Redis",
                })
                .end();

            throw e;
            }
        }
        );
    }

    async getAll(): Promise<AuthData[]> {
        await this.ensureConnection();

        console.log("Will get all auth data from Redis");

        return this.tracer.startActiveSpan(
        "RedisAPL.getAll",
        {
            attributes: {
            [SemanticAttributes.PEER_SERVICE]: OTEL_APL_SERVICE_NAME,
            },
            kind: SpanKind.CLIENT,
        },
        async (span: any) => {
            try {
            const allData = await this.client.hgetall(this.hashCollectionKey);

            console.log("Successfully retrieved all auth data from Redis");
            span.setStatus({ code: SpanStatusCode.OK }).end();

            return Object.values(allData || {}).map((data) => JSON.parse(data) as AuthData);
            } catch (e) {
            console.log("Failed to get all auth data from Redis");
            console.log(e);

            span.recordException(e as Error);
            span
                .setStatus({
                code: SpanStatusCode.ERROR,
                message: "Failed to get all auth data from Redis",
                })
                .end();

            throw e;
            }
        }
        );
    }

    async isReady(): Promise<AplReadyResult> {
        try {
        await this.ensureConnection();
        const ping = await this.client.ping();
        return ping === "PONG"
            ? { ready: true }
            : { ready: false, error: new Error("Redis server did not respond with PONG") };
        } catch (error) {
        return { ready: false, error: error as Error };
        }
    }

    async isConfigured(): Promise<AplConfiguredResult> {
        try {
        await this.ensureConnection();
        const ping = await this.client.ping();
        return ping === "PONG"
            ? { configured: true }
            : { configured: false, error: new Error("Redis connection not configured properly") };
        } catch (error) {
        return { configured: false, error: error as Error };
        }
    }
}