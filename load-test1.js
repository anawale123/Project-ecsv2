import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom per-endpoint metrics
const shortenFailRate = new Rate('shorten_fail_rate');
const statsFailRate   = new Rate('stats_fail_rate');
const shortenDuration = new Trend('shorten_duration', true);
const statsDuration   = new Trend('stats_duration', true);

export const options = {
  stages: [
    { duration: '3m', target: 400 },
    { duration: '1m', target: 600 },
    { duration: '3m', target: 800 },  
    { duration: '3m', target:  1000 },
    { duration: '3m', target: 1200 },
    { duration: '4m', target: 900 },
    { duration: '4m', target: 800 },
  ],
  thresholds: {
    
    'http_req_duration':  ['p(95)<2000'],
    'http_req_failed':    ['rate<0.01'],
    'shorten_fail_rate':  ['rate<0.01'],
    'stats_fail_rate':    ['rate<0.01'],
    'shorten_duration':   ['p(95)<2000'],
  },
};

export default function () {
  const payload = JSON.stringify({ url: 'https://example.com' });
  const params  = { headers: { 'Content-Type': 'application/json' } };
  const ts      = new Date().toISOString();  // timestamp for all logs this iteration

  // --- SHORTEN ---
  const shorten = http.post('https://url-shortener-aws.co.uk/shorten', payload, params);
  shortenDuration.add(shorten.timings.duration);

  const shortenOk = check(shorten, {
    'shorten status 200': (r) => r.status === 200,
    'shorten has short_url': (r) => {
      try {
        return JSON.parse(r.body).short !== undefined;
      } catch (e) {
        console.error(`[${ts}] VU=${__VU} JSON parse error: ${r.body.substring(0, 100)}`);
        return false;
      }
    },
  });

  shortenFailRate.add(!shortenOk);

  if (!shortenOk) {
    console.error(`[${ts}] SHORTEN FAIL VU=${__VU} status=${shorten.status} duration=${shorten.timings.duration}ms body=${shorten.body.substring(0, 100)}`);
  }

  sleep(1);

  // --- STATS (only if shorten succeeded) ---
  if (shorten.status === 200) {
    let code;
    try {
      code = JSON.parse(shorten.body).short;
    } catch (e) {
      return;
    }

    const stats   = http.get(`https://url-shortener-aws.co.uk/stats/${code}`);
    statsDuration.add(stats.timings.duration);

    const statsOk = check(stats, {
      'stats status 200': (r) => r.status === 200,
    });

    statsFailRate.add(!statsOk);

    if (!statsOk) {
      console.error(`[${ts}] STATS FAIL VU=${__VU} status=${stats.status} duration=${stats.timings.duration}ms`);
    }
  }

  sleep(1);
}
