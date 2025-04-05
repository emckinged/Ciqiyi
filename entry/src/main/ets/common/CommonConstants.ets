export class CommonConstants {
  /**
   * Video source url.
   * XX.XX.XX.XX: your pc ip address
   */
  static readonly VIDEO_SOURCE: string[] = [
    'https://prod-streaming-video-msn-com.akamaized.net/a8c412fa-f696-4ff2-9c76-e8ed9cdffe0f/604a87fc-e7bc-463e-8d56-cde7e661d690.mp4',
    'https://prod-streaming-video-msn-com.akamaized.net/0b927d99-e38a-4f51-8d1a-598fd4d6ee97/3493c85c-f35a-488f-9a8f-633e747fb141.mp4',
    'https://prod-streaming-video-msn-com.akamaized.net/178161a4-26a5-4f84-96d3-6acea1909a06/2213bcd0-7d15-4da0-a619-e32d522572c0.mp4',
  ];

  /**
   * Track thickness size min.
   */
  static readonly TRACK_SIZE_MIN: number = 4;

  /**
   * Track thickness borderRadius.
   */
  static readonly TRACK_BORDER_RADIUS: number = 2;

  /**
   * Track thickness size max.
   */
  static readonly TRACK_SIZE_MAX: number = 6;

  /**
   * The surface width.
   */
  static readonly SURFACE_WIDTH: number = 1920;

  /**
   * The surface height.
   */
  static readonly SURFACE_HEIGHT: number = 1080;
}